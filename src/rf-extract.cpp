#include <iostream>
#include <iomanip>
#include <cassert>
#include "feature.hpp"
using namespace std;

template<typename T>
void writeline(const vector<T>& v)
{
	cout << v[0];
	for (size_t i = 1, n = v.size(); i < n; ++i)
	{
		cout << ',' << v[i];
	}
	cout << endl;
}

int main(int argc, char* argv[])
{
	if (argc != 3)
	{
		cout << "Usage: rf-extract receptor.pdbqt ligand.pdbqt" << endl;
		return 0;
	}

	const vector<string> headers =
	{
		"6.6",
		"7.6",
		"8.6",
		"16.6",
		"6.7",
		"7.7",
		"8.7",
		"16.7",
		"6.8",
		"7.8",
		"8.8",
		"16.8",
		"6.16",
		"7.16",
		"8.16",
		"16.16",
		"6.15",
		"7.15",
		"8.15",
		"16.15",
		"6.9",
		"7.9",
		"8.9",
		"16.9",
		"6.17",
		"7.17",
		"8.17",
		"16.17",
		"6.35",
		"7.35",
		"8.35",
		"16.35",
		"6.53",
		"7.53",
		"8.53",
		"16.53",
		"gauss1_inter",
		"gauss2_inter",
		"repulsion_inter",
		"hydrophobic_inter",
		"hydrogenbonding_inter",
		"gauss1_intra",
		"gauss2_intra",
		"repulsion_intra",
		"hydrophobic_intra",
		"hydrogenbonding_intra",
		"flexibility",
	};
	writeline<string>(headers);

	// Load a receptor and multiple conformations of a ligand to calculate RF-Score features and Vina terms.
	cout.setf(ios::fixed, ios::floatfield);
	cout << setprecision(4);
	receptor rec;
	rec.load(argv[1]);
	for (ifstream ifs(argv[2]); true;)
	{
		ligand lig;
		lig.load(ifs);
		if (lig.empty()) break;
		const vector<float> v = feature(rec, lig);
		assert(v.size() == headers.size());
		writeline<float>(v);
	}
}
