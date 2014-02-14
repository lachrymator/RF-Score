#include <iostream>
#include <iomanip>
#include <string>
#include "feature.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc < 3)
	{
		cout << "Usage: rf-prepare /path/to/PDBbind/v2012/pdbbind-2012-core-iy.csv pdbbind-2012-core-yx42i.csv scheme" << endl;
		return 0;
	}

	// Traverse the PDBbind folder to extract RF-Score features and Vina terms.
	const string path = argv[1];
	const string root = path.substr(0, path.find_last_of("/\\") + 1);
	const string scheme = argc == 3 ? "1" : argv[3];
	string line;
	ofstream ofs(argv[2]);
	ofs.setf(ios::fixed, ios::floatfield);
	ofs << "pbindaff,6.6,7.6,8.6,16.6,6.7,7.7,8.7,16.7,6.8,7.8,8.8,16.8,6.16,7.16,8.16,16.16,6.15,7.15,8.15,16.15,6.9,7.9,8.9,16.9,6.17,7.17,8.17,16.17,6.35,7.35,8.35,16.35,6.53,7.53,8.53,16.53,gauss1_inter,gauss2_inter,repulsion_inter,hydrophobic_inter,hydrogenbonding_inter,gauss1_intra,gauss2_intra,repulsion_intra,hydrophobic_intra,hydrogenbonding_intra,flexibility,PDB\n" << setprecision(4);
	for (ifstream dataifs(argv[1]); getline(dataifs, line);)
	{
		const string code = line.substr(0, 4);
		const float pbindaff = stof(line.substr(5));
		receptor rec;
		rec.load(root + code + "/" + code + "_protein.pdbqt");
		vector<float> v;
		if (scheme == "1")
		{
			ligand lig;
			lig.load(root + code + "/" + code + "_ligand.pdbqt");
			v = feature(rec, lig);
		}
		else if (scheme == "5")
		{
			ifstream ifs(root + code + "/out/conformation_count.txt");
			getline(ifs, line);
			const size_t c = stoul(line);
			vector<float> t;
			v.resize((36 + 10) * 9 + 1);
			size_t p = 0;
			for (size_t i = c; i < 9; ++i)
			{
				ligand lig;
				lig.load(root + code + "/out/" + code + "_ligand_ligand_1.pdbqt");
				t = feature(rec, lig);
				for (size_t j = 0; j < 36 + 10; ++j)
				{
					v[p++] = t[j];
				}
			}
			for (size_t i = 1; i <= c; ++i)
			{
				ligand lig;
				lig.load(root + code + "/out/" + code + "_ligand_ligand_" + to_string(i) + ".pdbqt");
				t = feature(rec, lig);
				for (size_t j = 0; j < 36 + 10; ++j)
				{
					v[p++] = t[j];
				}
			}
			v[p++] = t.back();
		}
		else
		{
			ifstream ifs(root + code + "/vina-scheme-" + scheme + ".txt");
			getline(ifs, line);
			ligand lig;
			lig.load(root + code + "/out/" + code + "_ligand_ligand_" + line + ".pdbqt");
			v = feature(rec, lig);
		}
		ofs << pbindaff;
		for (const auto d : v)
		{
			ofs << ',' << d;
		}
		ofs << ',' << code << '\n';
	}
}
