#pragma once
#ifndef RF_SCORE_RECEPTOR_HPP
#define RF_SCORE_RECEPTOR_HPP

#include <vector>
#include <fstream>
#include "atom.hpp"

class receptor : public vector<atom>
{
public:
	/// Load current receptor from a file
	void load(const string path);

	/// Load current receptor from an ifstream
	void load(ifstream& ifs);
};

#endif
