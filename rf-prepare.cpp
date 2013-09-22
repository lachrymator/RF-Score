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
	ofs << setprecision(2);
	for (ifstream dataifs(argv[1]); getline(dataifs, line) && line[0] != '#';)
	{
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
