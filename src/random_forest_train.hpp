#pragma once
#ifndef RF_SCORE_RANDOM_FOREST_TRAIN_HPP
#define RF_SCORE_RANDOM_FOREST_TRAIN_HPP

#include <vector>
#include <array>
#include <random>
#include <functional>
#include <fstream>
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

	/// Construct an empty leaf node
	explicit node()
	{
		// Explicitly initialize child nodes because arrays of numeric types are not initialized to zero.
		children[0] = 0;
	}

	/// Save current node to an ofstream
	void save(ofstream& ofs) const;
};

class tree : public vector<node>
{
public:
	/// Train an empty tree from bootstrap samples
	void train(const vector<vector<float>>& x, const vector<float>& y, const size_t mtry, const function<double()>& u01, vector<float>& incPurity, vector<float>& incMSE, vector<float>& impSD, vector<float>& oobPreds, vector<size_t>& oobTimes);

	/// Save current tree to an ofstream
	void save(ofstream& ofs) const;
private:
	/// Predict the y value of the given sample x
	float operator()(const vector<float>& x) const;
};

class forest : public vector<tree>
{
public:
	/// Train trees
	void train(const vector<vector<float>>& x, const vector<float>& y, const size_t num_trees, const size_t mtry, const size_t seed);

	/// Save current forest to a file
	void save(const string path) const;

	/// Save current forest to an ofstream
	void save(ofstream& ofs) const;

	float mse; ///< Mean of squared residuals
	float rsq; ///< Var explained
	vector<float> incPurity; ///< Tgini
	vector<float> incMSE;
	vector<float> impSD;
private:
	mt19937_64 rng;
	uniform_real_distribution<double> uniform_01;
	function<double()> u01;
};

#endif
