#include <iostream>
#include <iomanip>
#include <algorithm>
#include "random_forest_test.hpp"
#include "feature.hpp"
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

	// Load a receptor and multiple ligands to calculate RF-Score features and Vina terms.
	cout.setf(ios::fixed, ios::floatfield);
	cout << setprecision(3);
	scoring_function sf;
	receptor rec;
	rec.load(argv[2]);
	for (ifstream ifs(argv[3]); true;)
	{
		ligand lig;
		lig.load(ifs);
		if (lig.empty()) break;
		const vector<float> v = feature(sf, rec, lig);
		cout << f(v) << endl;
	}
}
