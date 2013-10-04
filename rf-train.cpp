#include <iostream>
#include <iomanip>
#include <string>
#include <thread>
#include <algorithm>
#include "random_forest_train.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc != 3)
	{
		cout << "Usage: rf-train rf-train.csv rf.data" << endl;
		return 0;
	}

	// Parse training samples.
	string line;
	vector<vector<float>> x;
	x.reserve(1105);
	vector<float> y;
	y.reserve(x.capacity());
	ifstream ifs(argv[1]);
	getline(ifs, line);
	while (getline(ifs, line))
	{
		size_t c0 = line.find(',');
		y.push_back(stof(line.substr(0, c0)));
		vector<float> v;
		v.reserve(36);
		while (true)
		{
			const size_t c1 = line.find(',', c0 + 2);
			if (c1 == string::npos) break;
			v.push_back(stof(line.substr(c0 + 1, c1 - c0 - 1)));
			c0 = c1;
		}
		x.push_back(move(v));
	}
	ifs.close();

	// Train random forests of different mtry values in parallel.
	const size_t num_trees = 500;
	const size_t seed = 89757; // time(0), random_device()()
	const size_t num_threads = 4;
	const size_t min_mtry = 1;
	const size_t max_mtry = 1 + x.front().size() / 4;
	vector<forest> forests(max_mtry - min_mtry + 1);
	cout << "Training " << forests.size() << " random forests of " << num_trees << " trees with mtry from " << min_mtry << " to " << max_mtry << " and seed " << seed << " using " << num_threads << " threads" << endl;
	vector<thread> threads;
	threads.reserve(num_threads);
	const size_t avg = forests.size() / num_threads;
	const size_t spr = forests.size() - avg * num_threads;
	for (size_t tid = 0, beg = 0, end; tid < num_threads; ++tid)
	{
		end = beg + avg + (tid < spr);
		threads.emplace_back(([=, &forests, &x, &y]()
		{
			for (size_t i = beg; i < end; ++i)
			{
				forests[i].train(x, y, num_trees, min_mtry + i, seed);
			}
		}));
		beg = end;
	}
	for (auto& t : threads)
	{
		t.join();
	}

	// Choose the random forest that has the minimum MSE. The larger the mtry value, the more nodes the trees will have, and thus the larger size of rf.data. This can be verified by saving the forests of different mtry values.
	float best_mse = 1e9;
	size_t best_idx;
	for (size_t idx = 0; idx < forests.size(); ++idx)
	{
		const auto& f = forests[idx];
		if (f.mse < best_mse)
		{
			best_mse = f.mse;
			best_idx = idx;
		}
	}
	cout << "mtry = " << min_mtry + best_idx << " yields the minimum MSE" << endl;

	// Output statistics of the best random forest and save it to file.
	const auto& f = forests[best_idx];
	cout.setf(ios::fixed, ios::floatfield);
	cout << setprecision(3)
	     << "Mean of squared residuals: " << f.mse << endl
	     << "            Var explained: " << f.rsq << endl
	     << setw(3) << "Var" << setw(8) << "%incMSE" << setw(8) << "Tgini" << endl;
	for (size_t i = 0, num_variables = x.front().size(); i < num_variables; ++i)
	{
		cout << setw(3) << i << setw(8) << (f.incMSE[i] / f.impSD[i]) << setw(8) << f.incPurity[i] << endl;
	}
	f.save(argv[2]);
}
