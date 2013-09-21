#pragma once
#ifndef RF_SCORE_LIGAND_HPP
#define RF_SCORE_LIGAND_HPP

#include <vector>
#include <fstream>
#include "atom.hpp"

class ligand : public vector<atom>
{
public:
	/// Construct a ligand by parsing a ligand file in pdbqt format.
	explicit ligand(ifstream& ifs);
};

#endif
