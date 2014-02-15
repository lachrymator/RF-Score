#include <iostream>
#include <iomanip>
#include <string>
#include <thread>
#include <mutex>
#include <algorithm>
#include "random_forest_train.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc < 3)
	{
		cout << "Usage: rf-train pdbbind-2012-refined-core-yx42i.csv pdbbind-2012-refined-core-x42.rf seed" << endl;
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
	const size_t num_samples = y.size();
	const size_t num_variables = x.front().size();
	const size_t num_trees = 500;
	const size_t seed = argc == 3 ? 89757 : stoul(argv[3]); // time(0), random_device()()
	const size_t num_threads = thread::hardware_concurrency();
	const size_t min_mtry = 1;
	const size_t max_mtry = num_variables;
	const size_t num_forests = max_mtry - min_mtry + 1;
	cout << "Training " << num_forests << " random forests of " << num_trees << " trees with mtry from " << min_mtry << " to " << max_mtry << " and seed " << seed << " on " << num_samples << " samples using " << num_threads << " threads" << endl;
	mutex m;
	forest f;
	size_t mtry;
	vector<thread> threads;
	threads.reserve(num_threads);
	for (size_t tid = 0; tid < num_threads; ++tid)
	{
		threads.emplace_back([&,tid]()
		{
			for (size_t this_mtry = min_mtry + tid; this_mtry <= max_mtry; this_mtry += num_threads)
			{
				forest this_f;
				this_f.train(x, y, num_trees, this_mtry, seed);
				// Choose the random forest that has the minimum MSE. The larger the mtry value, the more nodes the trees will have, and thus the larger size of rf.data. This can be verified by saving the forests of different mtry values.
				lock_guard<mutex> guard(m);
				if (f.empty() || this_f.mse < f.mse)
				{
					f = move(this_f);
					mtry = this_mtry;
				}
			}
		});
	}
	for (auto& t : threads)
	{
		t.join();
	}

	cout << "mtry = " << mtry << " yields the minimum MSE" << endl;

	// Output statistics of the best random forest and save it to file.
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
