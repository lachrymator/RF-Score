#pragma once
#ifndef RF_SCORE_STATISTICS_HPP
#define RF_SCORE_STATISTICS_HPP

#include <vector>
#include <array>
using namespace std;

float pearson(const vector<float>& y, const vector<float>& x);
float spearman(const vector<float>& y, const vector<float>& x);
float kendall(const vector<float>& y, const vector<float>& x);
array<float, 5> stats(const vector<float>& y, const vector<float>& x);

#endif
