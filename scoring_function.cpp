#include <cmath>
#include "scoring_function.hpp"

const array<float, 15> scoring_function::vdw =
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

const array<float, 5> scoring_function::weights =
{
	-0.035579f,
	-0.005156f,
	 0.840245f,
	-0.035069f,
	-0.587439f,
};

/// Returns true if the XScore atom type is hydrophobic.
inline bool is_hydrophobic(const size_t t)
{
	return t ==  0 || t == 10 || t == 11 || t == 12 || t == 13;
}

/// Returns true if the XScore atom types are hydrophobic.
inline bool is_hydrophobic(const size_t t1, const size_t t2)
{
	return is_hydrophobic(t1) && is_hydrophobic(t2);
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

void scoring_function::score(vector<float>& t, const size_t t1, const size_t t2, const float r) const
{
	const float d = r - (vdw[t1] + vdw[t2]);
	t[0] += exp(-4.0f * d * d);
	t[1] += exp(-0.25f * (d - 3.0f) * (d - 3.0f));
	t[2] += d < 0.0f ? d * d : 0.0f;
	t[3] += is_hydrophobic(t1, t2) ? (d >= 1.5f ? 0.0f : (d <= 0.5f ? 1.0f : 1.5f - d)) : 0.0f;
	t[4] += is_hbond(t1, t2) ? (d >= 0.0f ? 0.0f : (d <= -0.7f ? 1.0f : d * -1.4285714285714286f)) : 0.0f;
}

void scoring_function::weight(vector<float>& t) const
{
	for (size_t i = 0; i < weights.size(); ++i)
	{
		t[i] *= weights[i];
	}
}