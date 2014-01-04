#include <iostream>
#include <iomanip>
#include <string>
#include "feature.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc != 3)
	{
		cout << "Usage: rf-prepare /path/to/PDBbind/v2012/pdbbind2012-core-iy.csv pdbbind2012-core-yx41i.csv" << endl;
		return 0;
	}

	// Traverse the PDBbind folder to extract RF-Score features and Vina terms.
	const string path = argv[1];
	const string root = path.substr(0, path.find_last_of("/\\") + 1);
	string line;
	ofstream ofs(argv[2]);
	ofs.setf(ios::fixed, ios::floatfield);
	ofs << "pbindaff,6.6,7.6,8.6,16.6,6.7,7.7,8.7,16.7,6.8,7.8,8.8,16.8,6.16,7.16,8.16,16.16,6.15,7.15,8.15,16.15,6.9,7.9,8.9,16.9,6.17,7.17,8.17,16.17,6.35,7.35,8.35,16.35,6.53,7.53,8.53,16.53,gauss1,gauss2,repulsion,hydrophobic,hydrogenbonding,flexibility,PDB\n" << setprecision(4);
	for (ifstream dataifs(argv[1]); getline(dataifs, line);)
	{
		const string code = line.substr(0, 4);
		const float pbindaff = stof(line.substr(5));
		receptor rec;
		rec.load(root + code + "/" + code + "_protein.pdbqt");
		ligand lig;
		lig.load(root + code + "/" + code + "_ligand.pdbqt");
		const vector<float> v = feature(rec, lig);
		ofs << pbindaff;
		for (const auto d : v)
		{
			ofs << ',' << d;
		}
		ofs << ',' << code << '\n';
	}
}
