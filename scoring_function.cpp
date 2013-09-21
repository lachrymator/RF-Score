#include <cmath>
#include "scoring_function.hpp"

const float scoring_function::cutoff_sqr = cutoff * cutoff;
const array<float, scoring_function::n> scoring_function::vdw =
{
	1.9f, //   C_H
	1.9f, //   C_P
	1.8f, //   N_P
	1.8f, //   N_D
	1.8f, //   N_A
	1.8f, //   N_DA
	1.7f, //   O_A
	1.7f, //   O_DA
	2.0f, //   S_P
	2.1f, //   P_P
	1.5f, //   F_H
	1.8f, //  Cl_H
	2.0f, //  Br_H
	2.2f, //   I_H
	1.2f, // Met_D
};

/// Returns true if the XScore atom type is hydrophobic.
inline bool is_hydrophobic(const size_t t)
{
	return t ==  0 || t == 10 || t == 11 || t == 12 || t == 13;
}

/// Returns true if the XScore atom type is a hydrogen bond donor.
inline bool is_hbdonor(const size_t t)
{
	return t ==  3 || t ==  5 || t ==  7 || t == 14;
}

/// Returns true if the XScore atom type is a hydrogen bond acceptor.
inline bool is_hbacceptor(const size_t t)
{
	return t ==  4 || t ==  5 || t ==  6 || t ==  7;
}

/// Returns true if the two XScore atom types are a pair of hydrogen bond donor and acceptor.
inline bool is_hbond(const size_t t1, const size_t t2)
{
	return (is_hbdonor(t1) && is_hbacceptor(t2)) || (is_hbdonor(t2) && is_hbacceptor(t1));
}

scoring_function::scoring_function() : e(ne), rs(nr)
{
	const float ns_inv = 1.0f / ns;
	for (size_t i = 0; i < nr; ++i)
	{
		rs[i] = sqrt(i * ns_inv);
	}
}

void scoring_function::precalculate(const size_t t1, const size_t t2)
{
	const size_t offset = nr * ((t2*(t2+1)>>1) + t1);
	const float s = vdw[t1] + vdw[t2];
	const bool hydrophobic = is_hydrophobic(t1) && is_hydrophobic(t2);
	const bool hbond = is_hbond(t1, t2);

	// Calculate the value of scoring function evaluated at (t1, t2, r).
	float* et = e.data() + offset;
	for (size_t i = 0; i < nr; ++i)
	{
		// Calculate the surface distance d.
		const float d = rs[i] - s;

		// The scoring function is a weighted sum of 5 terms. The first 3 terms depend on d only, while the latter 2 terms depend on t1, t2 and d.
		et[i] =
		    (-0.035579f) * exp(-4.0f * d * d)
		  + (-0.005156f) * exp(-0.25f * (d - 3.0f) * (d - 3.0f))
		  + (d < 0.0f ? 0.840245f * d * d : 0.0f)
		  + (hydrophobic ? (-0.035069f) * (d >= 1.5f ? 0.0f : (d <= 0.5f ? 1.0f : 1.5f - d)) : 0.0f)
		  + (hbond ? (-0.587439f) * (d >= 0.0f ? 0.0f : (d <= -0.7f ? 1.0f : d * -1.4285714285714286f)) : 0.0f);
	}
}

void scoring_function::clear()
{
	e.clear();
	rs.clear();
}

float scoring_function::score(const size_t t1, const size_t t2, const float r) const
{
	return e[nr * ((t2*(t2+1)>>1) + t1) + static_cast<size_t>(ns * r)];
}
