#include <string>
#include <fstream>
#include <cassert>
#include "ligand.hpp"

/// Represents a ROOT or a BRANCH in PDBQT structure.
class frame
{
public:
	size_t parent; ///< Frame array index pointing to the parent of current frame. For ROOT frame, this field is not used.
	size_t rotorXidx; ///< Index pointing to the parent frame atom which forms a rotatable bond with the rotorY atom of current frame.
	size_t rotorYidx; ///< Index pointing to the current frame atom which forms a rotatable bond with the rotorX atom of parent frame.

	/// Constructs an active frame, and relates it to its parent frame.
	explicit frame(const size_t parent, const size_t rotorXidx, const size_t rotorYidx) : parent(parent), rotorXidx(rotorXidx), rotorYidx(rotorYidx) {}
};

void ligand::load(const string path)
{
	ifstream ifs(path);
	load(ifs);
}

void ligand::load(ifstream& ifs)
{
	// Initialize necessary variables for constructing a ligand.
	num_active_torsions = num_inactive_torsions = 0;
	vector<frame> frames; ///< ROOT and BRANCH frames.
	frames.reserve(30); // A ligand typically consists of <= 30 frames.
	frames.emplace_back(0, 0, 0); // ROOT is also treated as a frame. The parent, rotorXsrn, rotorYsrn, rotorXidx of ROOT frame are dummy.
	reserve(100); // A ligand typically consists of <= 100 heavy atoms.

	// Initialize helper variables for parsing.
	vector<atom> hydrogens; ///< Unsaved hydrogens of ROOT frame.
	size_t current = 0; // Index of current frame, initialized to ROOT frame.
	frame* f = &frames.front(); // Pointer to the current frame.

	// Parse the ligand line by line.
	for (string line; getline(ifs, line);)
	{
		const string record = line.substr(0, 6);
		if (record == "ATOM  " || record == "HETATM")
		{
			// Parse the line.
			atom a(line);

			// Skip unsupported atom types.
			if (a.ad_unsupported()) continue;

			// Skip non-polar hydrogens.
			if (a.is_nonpolar_hydrogen()) continue;

			// For a polar hydrogen, the bonded hetero atom must be a hydrogen bond donor.
			if (a.is_polar_hydrogen())
			{
				bool unsaved = true;
				for (size_t i = size(); i > f->rotorYidx;)
				{
					atom& b = (*this)[--i];
					if (a.has_covalent_bond(b))
					{
						b.donorize();
						unsaved = false;
						break;
					}
				}
				if (unsaved)
				{
					hydrogens.push_back(move(a));
				}
			}
			else // Current atom is a heavy atom.
			{
				// Find bonds between the current atom and the other atoms of the same frame.
				for (size_t i = size(); i > f->rotorYidx;)
				{
					atom& b = (*this)[--i];
					if (a.has_covalent_bond(b))
					{
						// If carbon atom b is bonded to hetero atom a, b is no longer a hydrophobic atom.
						if (a.is_hetero() && !b.is_hetero())
						{
							b.dehydrophobicize();
						}
						// If carbon atom a is bonded to hetero atom b, a is no longer a hydrophobic atom.
						else if (!a.is_hetero() && b.is_hetero())
						{
							a.dehydrophobicize();
						}
					}
				}

				// Save the heavy atom.
				push_back(move(a));
			}
		}
		else if (record == "BRANCH")
		{
			// Parse "BRANCH   X   Y". X and Y are right-justified and 4 characters wide.
			const size_t rotorXsrn = stoul(line.substr( 6, 4));
			const size_t rotorYsrn = stoul(line.substr(10, 4));

			// Find the corresponding heavy atom with x as its atom serial number in the current frame.
			for (size_t i = f->rotorYidx; true; ++i)
			{
				if ((*this)[i].serial == rotorXsrn)
				{
					// Insert a new frame whose parent is the current frame.
					frames.push_back(frame(current, i, size()));
					break;
				}
			}

			// Now the current frame is the newly inserted BRANCH frame.
			current = frames.size() - 1;

			// Update the pointer to the current frame.
			f = &frames[current];
		}
		else if (record == "ENDBRA")
		{
			// If the current frame consists of rotor Y and a few hydrogens only, e.g. -OH, -NH2 or -CH3,
			// the torsion of this frame will have no effect on scoring and is thus redundant.
			if (current + 1 == frames.size() && f->rotorYidx + 1 == size())
			{
				++num_inactive_torsions;
			}
			else
			{
				++num_active_torsions;
			}

			// Dehydrophobicize rotorX and rotorY if necessary.
			atom& rotorY = (*this)[f->rotorYidx];
			atom& rotorX = (*this)[f->rotorXidx];
			if (rotorY.is_hetero() && !rotorX.is_hetero()) rotorX.dehydrophobicize();
			if (rotorX.is_hetero() && !rotorY.is_hetero()) rotorY.dehydrophobicize();

			// Now the parent of the following frame is the parent of current frame.
			current = f->parent;

			// Update the pointer to the current frame.
			f = &frames[current];
		}
		else if (record == "ENDROO")
		{
			for (const atom& a : hydrogens)
			{
				for (size_t i = size(); i > f->rotorYidx;)
				{
					atom& b = (*this)[--i];
					if (a.has_covalent_bond(b))
					{
						b.donorize();
						break;
					}
				}
			}
		}
		else if (record == "TORSDO") break;
	}
	assert(1 + num_active_torsions + num_inactive_torsions == frames.size());
}
