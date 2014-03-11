#pragma once
#ifndef RF_SCORE_STATISTICS_HPP
#define RF_SCORE_STATISTICS_HPP

#include <iostream>
#include <vector>
#include <numeric>
#include <algorithm>
using namespace std;

float pearson(const vector<float>& x, const vector<float>& y);
float spearman(const vector<float>& x, const vector<float>& y);
float kendall(const vector<float>& x, const vector<float>& y);
void stats(const vector<float>& x, const vector<float>& y);

#endif
