#pragma once
#ifndef RF_SCORE_RANDOM_FOREST_TEST_HPP
#define RF_SCORE_RANDOM_FOREST_TEST_HPP

#include <vector>
#include <array>
#include <random>
#include <mutex>
#include <functional>
using namespace std;

class node
{
public:
	vector<size_t> samples; ///< Node samples
	float y; ///< Average of y values of node samples
	float p; ///< Node purity, measured as either y * y * nSamples or sum * sum / nSamples
	size_t var; ///< Variable used for node split
	float val; ///< Value used for node split
	array<size_t, 2> children; ///< Two child nodes

	/// Constructs an empty leaf node.
	explicit node()
	{
		children[0] = 0;
	}

	node(const node&) = default;
	node(node&&) = default;
	node& operator=(const node&) = default;
	node& operator=(node&&) = default;
};

class tree : public vector<node>
{
public:
	/// Train an empty tree from bootstrap samples
	int train(const vector<vector<float>>& x, const vector<float>& y, const size_t mtry, const function<float()> u01);

	/// Predict the y value of the given sample x
	float operator()(const vector<float>& x) const;

	/// Calculate statistics
	void stats(const vector<vector<float>>& x, const vector<float>& y, vector<float>& incPurity, vector<float>& incMSE, vector<float>& impSD, vector<float>& oobPreds, vector<size_t>& oobTimes, const function<float()> u01) const;

	/// Clear node samples to save memory
	void clear();
};

class forest : public vector<tree>
{
public:
	forest(const size_t num_trees, const vector<vector<float>>& x, const vector<float>& y, const size_t mtry, const size_t seed);

	/// Train trees from beg to end
	void train(const size_t beg, const size_t end);

	/// Predict the y value of the given sample x
	float operator()(const vector<float>& x) const;

	/// Calculate statistics
	void stats() const;

	/// Clear node samples to save memory
	void clear();
private:
	/// Get a random value from uniform distribution in [0, 1]
	float get_uniform_01();

	/// Get a random value from uniform distribution in [0, 1] in a thread safe manner.
	float get_uniform_01_s();

	const vector<vector<float>>& x;
	const vector<float>& y;
	const size_t mtry;
	const function<float()> u01;
	const function<float()> u01_s;
	mt19937_64 rng;
	uniform_real_distribution<float> uniform_01;
	mutable mutex m;
};

#endif
