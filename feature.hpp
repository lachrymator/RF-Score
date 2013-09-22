#pragma once
#ifndef RF_SCORE_FEATURE_HPP
#define RF_SCORE_FEATURE_HPP

#include "scoring_function.hpp"
#include "receptor.hpp"
#include "ligand.hpp"
using namespace std;

inline vector<float> feature(const scoring_function& sf, const receptor& rec, const ligand& lig)
{
	vector<float> v(41); // 36 RF-Score features and 5 Vina terms
	for (const auto& l : lig)
	{
		for (const auto& r : rec)
		{
			const float d0 = l.coord[0] - r.coord[0];
			const float d1 = l.coord[1] - r.coord[1];
			const float d2 = l.coord[2] - r.coord[2];
			const float ds = d0 * d0 + d1 * d1 + d2 * d2;
			if (ds >= 144) continue; // RF-Score cutoff 12A
			if (!l.rf_unsupported() && !r.rf_unsupported())
			{
				++v[(l.rf << 2) + r.rf];
			}
			if (ds >= 64) continue; // Vina score cutoff 8A
			if (!l.xs_unsupported() && !r.xs_unsupported())
			{
				sf.score(v.data() + 36, l.xs, r.xs, sqrt(ds));
			}
		}
	}
	sf.weight(v.data() + 36); // The 5 Vina terms are now weighted.
	return v;
}

#endif
