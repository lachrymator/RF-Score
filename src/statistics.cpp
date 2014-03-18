#include <numeric>
#include <algorithm>
#include "statistics.hpp"

float pearson(const vector<float>& y, const vector<float>& x)
{
	const size_t n = y.size();
	float x1sum = 0, y1sum = 0, x2sum = 0, y2sum = 0, xysum = 0;
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

float spearman(const vector<float>& y, const vector<float>& x)
{
	const size_t n = y.size();
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
		yrank[ycase[i]] = i + 1;
	}
	return pearson(yrank, xrank);
}

template <typename T>
inline int sgn(T x)
{
	return (static_cast<T>(0) < x) - (x < static_cast<T>(0));
}

float kendall(const vector<float>& y, const vector<float>& x)
{
	const size_t n = y.size();
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

array<float, 5> stats(const vector<float>& y, const vector<float>& x)
{
	const size_t n = y.size();
	float se1 = 0, se2 = 0;
	for (size_t i = 0; i < n; ++i)
	{
		se1 +=  x[i] - y[i];
		se2 += (x[i] - y[i]) * (x[i] - y[i]);
	}
	const array<float, 5> r = // rmse,sdev,pcor,scor,kcor
	{
		sqrt(se2 / n),
		sqrt(se2 / (n - 1)), // (se2 - se1 * se1 / n) / (n - 1)
		pearson(y, x),
		spearman(y, x),
		kendall(y, x),
	};
	return r;
}
