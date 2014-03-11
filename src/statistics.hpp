#pragma once
#ifndef RF_SCORE_STATISTICS_HPP
#define RF_SCORE_STATISTICS_HPP

#include <vector>
#include <array>
using namespace std;

float pearson(const vector<float>& x, const vector<float>& y);
float spearman(const vector<float>& x, const vector<float>& y);
float kendall(const vector<float>& x, const vector<float>& y);
array<float, 5> stats(const vector<float>& x, const vector<float>& y);

#endif
