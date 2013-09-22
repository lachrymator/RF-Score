#include <iostream>
#include <iomanip>
#include <algorithm>
#include "random_forest_test.hpp"
#include "scoring_function.hpp"
#include "receptor.hpp"
#include "ligand.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc != 4)
	{
		cout << "Usage: rf-score rf.data receptor.pdbqt ligand.pdbqt" << endl;
		return 0;
	}

	// Load a random forest from file.
	forest f;
	f.load(argv[1]);

	// Load receptor and ligand to calculate RF-Score features and Vina terms.
	cout.setf(ios::fixed, ios::floatfield);
	cout << setprecision(3);
	scoring_function sf;
	receptor rec;
	rec.load(argv[2]);
	ifstream ligifs(argv[3]);
	while (true)
	{
		ligand lig;
		lig.load(ligifs);
		if (lig.empty()) break;
		vector<float> v(36);
		vector<float> t(5);
		for (const auto& l : lig)
		{
			for (const auto& r : rec)
			{
				const float d0 = l.coord[0] - r.coord[0];
				const float d1 = l.coord[1] - r.coord[1];
				const float d2 = l.coord[2] - r.coord[2];
				const float ds = d0 * d0 + d1 * d1 + d2 * d2;
				if (ds >= 144) continue; // RF-Score cutoff
				if (!l.rf_unsupported() && !r.rf_unsupported())
				{
					++v[(l.rf << 2) + r.rf];
				}
				if (ds >= 64) continue; // Vina score cutoff
				if (!l.xs_unsupported() && !r.xs_unsupported())
				{
					sf.score(t, l.xs, r.xs, sqrt(ds));
				}
			}
		}
		cout << f(v) << endl;
		sf.weight(t); // The 5 Vina terms are now weighted.
	}
}
