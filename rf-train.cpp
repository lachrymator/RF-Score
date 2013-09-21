#include <iostream>
#include <iomanip>
#include <thread>
#include <algorithm>
#include "random_forest_train.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc != 3)
	{
		cout << "Usage: rf-train train.csv rf.data" << endl;
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
		x.push_back(static_cast<vector<float>&&>(v));
	}
	ifs.close();

	// Train a random forest in parallel.
	const size_t num_trees = 500;
	const size_t mtry = 5;
	const size_t seed = 89757; // time(0)
	const size_t num_threads = 2;
	cout << "Training " << num_trees << " trees with mtry " << mtry << " and seed " << seed << " in parallel using " << num_threads << " threads" << endl;
	forest f(num_trees, x, y, mtry, seed);
	vector<thread> t;
	t.reserve(num_threads);
	const size_t avg = num_trees / num_threads;
	const size_t spr = num_trees - avg * num_threads;
	for (size_t i = 0, beg = 0, end; i < num_threads; ++i)
	{
		t.push_back(thread(bind(&forest::train, ref(f), beg, end = beg + avg + (i < spr))));
		beg = end;
	}
	for (size_t i = 0; i < num_threads; ++i)
	{
		t[i].join();
	}

	// Calculate statistics
	cout.setf(ios::fixed, ios::floatfield);
	cout << setprecision(3);
	f.stats();

	// Save the random forest to file.
	ofstream ofs(argv[2]);
	f.save(ofs);
}
