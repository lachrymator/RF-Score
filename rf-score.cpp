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
	ifstream dataifs(argv[1]);
	f.load(dataifs);
	dataifs.close();

	/// Precalculate Vina's scoring function.
	scoring_function sf;
	for (size_t t2 = 0; t2 < sf.n; ++t2)
	for (size_t t1 = 0; t1 <=  t2; ++t1)
	{
		sf.precalculate(t1, t2);
	}
	sf.clear();

	// Parse receptor and ligand to calculate RF-Score features and Vina terms.
	cout.setf(ios::fixed, ios::floatfield);
	cout << setprecision(3);
	ifstream recifs(argv[2]);
	receptor rec(recifs);
	recifs.close();
	ifstream ligifs(argv[3]);
	while (true)
	{
		ligand lig(ligifs);
		if (lig.empty()) break;
		vector<float> v(36);
		for (const auto& l : lig)
		{
			for (const auto& r : rec)
			{
				const auto d0 = l.coord[0] - r.coord[0];
				const auto d1 = l.coord[1] - r.coord[1];
				const auto d2 = l.coord[2] - r.coord[2];
				if (d0*d0 + d1*d1 + d2*d2 >= 144) continue;
				++v[l.rf * 4 + r.rf];
			}
		}
		cout << f(v) << endl;
	}
}
