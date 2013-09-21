#include <iostream>
#include <iomanip>
#include <fstream>
#include <thread>
#include <algorithm>
#include "random_forest_train.hpp"
using namespace std;

inline float pearson(const vector<float>& x, const vector<float>& y)
{
	float x1sum = 0, y1sum = 0, x2sum = 0, y2sum = 0, xysum = 0;
	const auto n = x.size();
	for (size_t i = 0; i < n; ++i)
	{
		x1sum += x[i];
		y1sum += y[i];
		x2sum += x[i] * x[i];
		y2sum += y[i] * y[i];
		xysum += x[i] * y[i];
	}
	return (n*xysum-x1sum*y1sum)/sqrt((n*x2sum-x1sum*x1sum)*(n*y2sum-y1sum*y1sum));
}

inline float spearman(const vector<float>& x, const vector<float>& y)
{
	const auto n = y.size();
	vector<size_t> xcase(n), ycase(n);
	iota(xcase.begin(), xcase.end(), 0);
	iota(ycase.begin(), ycase.end(), 0);
	sort(xcase.begin(), xcase.end(), [&x](size_t val1, size_t val2)
	{
		return x[val1] < x[val2];
	});
	sort(ycase.begin(), ycase.end(), [&y](size_t val1, size_t val2)
	{
		return y[val1] < y[val2];
	});
	vector<float> xrank(n), yrank(n);
	for (size_t i = 0; i < n; ++i)
	{
		xrank[xcase[i]] = i + 1;
	}
	for (size_t i = 0; i < n; ++i)
	{
		yrank[ycase[i]] = i + 1;
	}
	return pearson(xrank, yrank);
}

template <typename T>
inline int sgn(T x)
{
	return (static_cast<T>(0) < x) - (x < static_cast<T>(0));
}

inline float kendall(const vector<float>& x, const vector<float>& y)
{
	const auto n = y.size();
	float numer = 0;
	for (size_t i = 0; i < n - 1; ++i)
	{
		for (size_t j = i + 1; j < n; ++j)
		{
		    numer += sgn(x[i] - x[j]) * sgn(y[i] - y[j]);
		}
	}
	return numer / (0.5 * n * (n-1));
}

static void stats(const vector<float>& x, const vector<float>& y)
{
	const auto n = y.size();
	float se1 = 0, se2 = 0;
	for (size_t i = 0; i < n; ++i)
	{
		se1 +=  x[i] - y[i];
		se2 += (x[i] - y[i]) * (x[i] - y[i]);
	}
	cout << "rmse " << sqrt(se2 / n) << endl;
	cout << "sdev " << (se2 - se1 * se1 / n) / (n - 1) << endl;
	cout << "pcor " <<  pearson(x, y) << endl;
	cout << "scor " << spearman(x, y) << endl;
	cout << "kcor " <<  kendall(x, y) << endl;
}

int main(int argc, char* argv[])
{
	if (argc != 4)
	{
		cout << "Usage: rf train.csv test.csv pred.csv" << endl;
		return 0;
	}

	// Parse training samples.
	string line;
	vector<vector<float>> trnx;
	trnx.reserve(1105);
	vector<float> trny;
	trny.reserve(trnx.capacity());
	ifstream trnifs(argv[1]);
	getline(trnifs, line);
	while (getline(trnifs, line))
	{
		size_t c0 = line.find(',');
		trny.push_back(stof(line.substr(0, c0)));
		vector<float> v;
		v.reserve(36);
		while (true)
		{
			const size_t c1 = line.find(',', c0 + 2);
			if (c1 == string::npos) break;
			v.push_back(stof(line.substr(c0 + 1, c1 - c0 - 1)));
			c0 = c1;
		}
		trnx.push_back(static_cast<vector<float>&&>(v));
	}
	trnifs.close();

	// Train a random forest in parallel.
	const size_t num_trees = 500;
	const size_t mtry = 5;
	const size_t seed = 89757; // time(0)
	const size_t num_threads = 2;
	cout << "Training " << num_trees << " trees with mtry " << mtry << " and seed " << seed << " in parallel using " << num_threads << " threads" << endl;
	forest f(num_trees, trnx, trny, mtry, seed);
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
	f.clear();

	// Evaluate prediction performance on training samples.
	cout << "Prediction on " << trny.size() << " training samples" << endl;
	vector<float> trnp;
	trnp.reserve(trny.size());
	for (const auto v : trnx)
	{
		trnp.push_back(f(v));
	}
	stats(trnp, trny);
	trnp.clear();
	trnx.clear();
	trny.clear();

	// Parse testing samples, predict RF-Score and write output to file.
	vector<float> tstp;
	tstp.reserve(195);
	vector<float> tsty;
	tsty.reserve(tstp.capacity());
	vector<float> v;
	ifstream tstifs(argv[2]);
	getline(tstifs, line);
	ofstream prdofs(argv[3]);
	prdofs.setf(ios::fixed, ios::floatfield);
	prdofs << "PDB,RF-Score,pbindaff" << endl << setprecision(2);
	while (getline(tstifs, line))
	{
		size_t c0 = line.find(',');
		const float y = stof(line.substr(0, c0));
		tsty.push_back(y);
		vector<float> v;
		v.reserve(36);
		while (true)
		{
			const size_t c1 = line.find(',', c0 + 2);
			if (c1 == string::npos) break;
			v.push_back(stof(line.substr(c0 + 1, c1 - c0 - 1)));
			c0 = c1;
		}
		const float p = f(v);
		tstp.push_back(p);
		prdofs << line.substr(c0 + 1) << ',' << p << ',' << y << endl;
	}
	prdofs.close();
	tstifs.close();

	// Evaluate prediction performance on testing samples.
	cout << "Prediction on " << tsty.size() << " testing samples" << endl;
	stats(tstp, tsty);
}
