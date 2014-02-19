#include <iostream>
#include <iomanip>
#include <string>
#include <algorithm>
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
	ofs << "pbindaff,gauss1_inter_1,gauss2_inter_1,repulsion_inter_1,hydrophobic_inter_1,hydrogenbonding_inter_1,gauss1_intra_1,gauss2_intra_1,repulsion_intra_1,hydrophobic_intra_1,hydrogenbonding_intra_1,gauss1_inter_2,gauss2_inter_2,repulsion_inter_2,hydrophobic_inter_2,hydrogenbonding_inter_2,gauss1_intra_2,gauss2_intra_2,repulsion_intra_2,hydrophobic_intra_2,hydrogenbonding_intra_2,nacttors,ninacttors,PDB\n" << setprecision(4);
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
		else if (scheme == "5" || scheme == "6")
		{
			ifstream ifs(root + code + "/out/conformation_count.txt");
			getline(ifs, line);
			const size_t c = stoul(line);
			const size_t n = scheme == "6" ? 2 : 9;
			const size_t m = min<size_t>(c, n);
			vector<float> t;
			v.resize((10) * n + 2);
			size_t p = 0;
			for (size_t i = c; i < n; ++i)
			{
				ligand lig;
				lig.load(root + code + "/out/" + code + "_ligand_ligand_1.pdbqt");
				t = feature(rec, lig);
				for (size_t j = 0; j < 10; ++j)
				{
					v[p++] = t[j];
				}
			}
			for (size_t i = 1; i <= m; ++i)
			{
				ligand lig;
				lig.load(root + code + "/out/" + code + "_ligand_ligand_" + to_string(i) + ".pdbqt");
				t = feature(rec, lig);
				for (size_t j = 0; j < 10; ++j)
				{
					v[p++] = t[j];
				}
			}
			v[p++] = t[10];
			v[p++] = t[11];
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
