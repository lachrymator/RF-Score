#pragma once
#ifndef RF_SCORE_RECEPTOR_HPP
#define RF_SCORE_RECEPTOR_HPP

#include <vector>
#include <fstream>
#include "atom.hpp"

class receptor : public vector<atom>
{
public:
	/// Construct a receptor by parsing a receptor file in pdbqt format.
	explicit receptor(ifstream& ifs);
};

#endif
