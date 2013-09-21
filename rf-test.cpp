#include <iostream>
#include <iomanip>
#include <algorithm>
#include "random_forest_test.hpp"
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
	cout << "N " << n << endl;
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
		cout << "Usage: rf-test rf.data test.csv pred.csv" << endl;
		return 0;
	}

	// Load a random forest from file.
	forest f;
	ifstream dataifs(argv[1]);
	f.load(dataifs);
	dataifs.close();

	// Parse testing samples, predict RF-Score and write output to file.
	string line;
	vector<float> p;
	p.reserve(195);
	vector<float> y;
	y.reserve(p.capacity());
	vector<float> v;
	ifstream tstifs(argv[2]);
	getline(tstifs, line);
	ofstream prdofs(argv[3]);
	prdofs.setf(ios::fixed, ios::floatfield);
	prdofs << "PDB,RF-Score,pbindaff" << endl << setprecision(2);
	while (getline(tstifs, line))
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
		p.push_back(f(v));
		prdofs << line.substr(c0 + 1) << ',' << p.back() << ',' << y.back() << endl;
	}
	prdofs.close();
	tstifs.close();

	// Evaluate prediction performance on testing samples.
	cout.setf(ios::fixed, ios::floatfield);
	cout << setprecision(3);
	stats(p, y);
}
