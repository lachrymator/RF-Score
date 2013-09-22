#pragma once
#ifndef RF_SCORE_RANDOM_FOREST_TEST_HPP
#define RF_SCORE_RANDOM_FOREST_TEST_HPP

#include <vector>
#include <array>
#include <fstream>
using namespace std;

class node
{
public:
	float y; ///< Average of y values of node samples
	size_t var; ///< Variable used for node split
	float val; ///< Value used for node split
	array<size_t, 2> children; ///< Two child nodes

	/// Load current node from an ifstream
	void load(ifstream& ifs);
};

class tree : public vector<node>
{
public:
	/// Load current tree from an ifstream
	void load(ifstream& ifs);

	/// Predict the y value of the given sample x
	float operator()(const vector<float>& x) const;
};

class forest : public vector<tree>
{
public:
	/// Load current forest from a file
	void load(const string path);

	/// Load current forest from an ifstream
	void load(ifstream& ifs);

	/// Predict the y value of the given sample x
	float operator()(const vector<float>& x) const;
};

#endif
