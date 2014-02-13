#pragma once
#ifndef RF_SCORE_LIGAND_HPP
#define RF_SCORE_LIGAND_HPP

#include <vector>
#include <fstream>
#include "atom.hpp"

class ligand : public vector<atom>
{
public:
	/// Load current ligand from a file
	void load(const string path);

	/// Load current ligand from an ifstream
	void load(ifstream& ifs);

	/// Variables to calculate Nrot.
	size_t num_active_torsions;
	size_t num_inactive_torsions;

	//! Represents a pair of interacting atoms that are separated by 3 consecutive covalent bonds.
	class interacting_pair
	{
	public:
		size_t i0; //!< Index of atom 0.
		size_t i1; //!< Index of atom 1.

		//! Constructs a pair of non 1-4 interacting atoms.
		interacting_pair(const size_t i0, const size_t i1) : i0(i0), i1(i1) {}
	};

	vector<interacting_pair> interacting_pairs; //!< Non 1-4 interacting pairs.
};

#endif
