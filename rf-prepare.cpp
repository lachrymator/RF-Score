#include <iostream>
#include <iomanip>
#include "feature.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc != 3)
	{
		cout << "Usage: rf-prepare /path/to/INDEX_core_data.2012 rf-test.csv" << endl;
		return 0;
	}

	// Load a receptor and a ligand to calculate RF-Score features and Vina terms.
	const string path = argv[1];
	const string root = path.substr(0, path.find_last_of("/\\") + 1);
	string line;
	ofstream ofs(argv[2]);
	ofs.setf(ios::fixed, ios::floatfield);
	ofs << "pbindaff,6.6,7.6,8.6,16.6,6.7,7.7,8.7,16.7,6.8,7.8,8.8,16.8,6.16,7.16,8.16,16.16,6.15,7.15,8.15,16.15,6.9,7.9,8.9,16.9,6.17,7.17,8.17,16.17,6.35,7.35,8.35,16.35,6.53,7.53,8.53,16.53,gauss1,gauss2,repulsion,hydrophobic,hydrogenbonding,PDB\n" << setprecision(2);
	for (ifstream dataifs(argv[1]); getline(dataifs, line);)
	{
		if (line[0] == '#') continue;
		const string code = line.substr(0, 4);
		const float pbindaff = stof(line.substr(18, 6));
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
