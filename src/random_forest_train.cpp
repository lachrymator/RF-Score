#include <numeric>
#include <algorithm>
#include "random_forest_train.hpp"

node::node()
{
	children[0] = 0;
}

void node::save(ofstream& ofs) const
{
	const unsigned int var = this->var;
	const unsigned int c0 = this->children[0];
	const unsigned int c1 = this->children[1];
	ofs.write((char*)&y, 4);
	ofs.write((char*)&var, 4);
	ofs.write((char*)&val, 4);
	ofs.write((char*)&c0, 4);
	ofs.write((char*)&c1, 4);
}

void tree::train(const vector<vector<float>>& x, const vector<float>& y, const size_t mtry, const function<double()>& u01, vector<float>& incPurity, vector<float>& incMSE, vector<float>& impSD, vector<float>& oobPreds, vector<size_t>& oobTimes)
{
	const size_t num_samples = x.size();
	const size_t num_variables = x.front().size();

	// Create bootstrap samples with replacement
	reserve((num_samples << 1) - 1);
	emplace_back();
	node& root = front();
	root.samples.resize(num_samples);
	for (size_t& s : root.samples)
	{
		s = static_cast<size_t>(u01() * num_samples);
	}

	// Populate nodes
	for (size_t k = 0; k < size(); ++k)
	{
		node& n = (*this)[k];

		// Evaluate node y and purity
		float sum = 0;
		for (const size_t s : n.samples) sum += y[s];
		n.y = sum / n.samples.size();
		n.p = n.y * n.y * n.samples.size(); // Equivalent to sum * sum / n.samples.size()

		// Do not split the node if it contains too few samples
		if (n.samples.size() <= 5) continue;

		// Find the best split that has the highest increase in node purity
		float bestChildNodePurity = n.p;
		vector<size_t> mind(num_variables);
		iota(mind.begin(), mind.end(), 0);
		for (size_t i = 0; i < mtry; ++i)
		{
			// Randomly select a variable without replacement
			const size_t j = static_cast<size_t>(u01() * (num_variables - i));
			const size_t v = mind[j];
			mind[j] = mind[num_variables - i - 1];

			// Sort the samples in ascending order of the selected variable
			vector<size_t> ncase(n.samples.size());
			iota(ncase.begin(), ncase.end(), 0);
			sort(ncase.begin(), ncase.end(), [&x, &n, v](const size_t val1, const size_t val2)
			{
				return x[n.samples[val1]][v] < x[n.samples[val2]][v];
			});

			// Search through the gaps in the selected variable
			float suml = 0;
			float sumr = sum;
			size_t popl = 0;
			size_t popr = n.samples.size();
			for (size_t j = 0; j < n.samples.size() - 1; ++j)
			{
				const float d = y[n.samples[ncase[j]]];
				suml += d;
				sumr -= d;
				++popl;
				--popr;
				if (x[n.samples[ncase[j]]][v] == x[n.samples[ncase[j+1]]][v]) continue;
				const float curChildNodePurity = (suml * suml / popl) + (sumr * sumr / popr);
				if (curChildNodePurity > bestChildNodePurity)
				{
					bestChildNodePurity = curChildNodePurity;
					n.var = v;
					n.val = (x[n.samples[ncase[j]]][v] + x[n.samples[ncase[j+1]]][v]) * .5f;
				}
			}
		}

		// Do not split the node if purity does not increase
		if (bestChildNodePurity == n.p) continue;

		// Create two child nodes and distribute samples
		n.children[0] = size();
		emplace_back();
		n.children[1] = size();
		emplace_back();
		for (const size_t s : n.samples)
		{
			(*this)[n.children[x[s][n.var] > n.val]].samples.push_back(s);
		}
	}

	// Aggregate NodeIncPurity
	for (const auto& n : *this)
	{
		if (!n.children[0]) continue;
		incPurity[n.var] += (*this)[n.children[0]].p + (*this)[n.children[1]].p - n.p;
	}

	// Find the samples used in bootstrap
	vector<size_t> in(num_samples, 0);
	for (const auto s : front().samples)
	{
		++in[s];
	}

	// Find the out-of-bag samples and calculate the OOB error without permutation
	vector<size_t> oob;
	oob.reserve(num_samples);
	float ooberr = 0;
	for (size_t s = 0; s < num_samples; ++s)
	{
		if (in[s]) continue;
		oob.push_back(s);
		const auto p = (*this)(x[s]);
		ooberr += (p - y[s]) * (p - y[s]);
		oobPreds[s] += p;
		++oobTimes[s];
	}

	// Generate a permutation of OOB samples for use in all variables
	vector<size_t> perm(oob);
	for (size_t i = 1; i < perm.size(); ++i)
	{
		const auto j = static_cast<size_t>(u01() * (perm.size() - i + 1));
		const auto tmp = perm[perm.size() - i];
		perm[perm.size() - i] = perm[j];
		perm[j] = tmp;
	}

	// Aggregate incMSE and impSD
	for (size_t v = 0; v < num_variables; ++v)
	{
		float ooberrperm = 0;
		for (size_t i = 0; i < oob.size(); ++i)
		{
			auto permx = x[oob[i]];
			permx[v] = x[perm[i]][v];
			const auto p = (*this)(permx);
			ooberrperm += (p - y[oob[i]]) * (p - y[oob[i]]);
		}
		const auto delta = (ooberrperm - ooberr) / oob.size();
		incMSE[v] += delta;
		impSD[v] += delta * delta;
	}
}

float tree::operator()(const vector<float>& x) const
{
	size_t k;
	for (k = 0; (*this)[k].children[0]; k = (*this)[k].children[x[(*this)[k].var] > (*this)[k].val]);
	return (*this)[k].y;
}

void tree::save(ofstream& ofs) const
{
	const unsigned int nn = size();
	ofs.write((char*)&nn, 4);
	for (const auto& n : *this)
	{
		n.save(ofs);
	}
}

void forest::train(const vector<vector<float>>& x, const vector<float>& y, const size_t num_trees, const size_t mtry, const size_t seed)
{
	// Initialize
	resize(num_trees);
	rng.seed(seed);
	u01 = [&]()
	{
		return uniform_01(rng);
	};

	// Aggregate the statistics over all trees of the random forest
	const size_t num_samples = x.size();
	const size_t num_variables = x.front().size();
	incPurity.resize(num_variables, 0);
	incMSE.resize(num_variables, 0);
	impSD.resize(num_variables, 0);
	vector<float> oobPreds(num_samples, 0);
	vector<size_t> oobTimes(num_samples, 0);
	for (auto& t : *this)
	{
		t.train(x, y, mtry, u01, incPurity, incMSE, impSD, oobPreds, oobTimes);
	}

	// Normalize incPurity, incMSE, impSD
	for (size_t i = 0; i < num_variables; ++i)
	{
		incPurity[i] /= size();
		incMSE[i] /= size();
		impSD[i] = sqrt((impSD[i] / size() - incMSE[i] * incMSE[i]) / size());
	}

	// Normalize oobPreds to calculate MSE
	mse = 0;
	size_t jout = 0;
	for (size_t s = 0; s < num_samples; ++s)
	{
		if (!oobTimes[s]) continue;
		const auto p = oobPreds[s] / oobTimes[s];
		mse += (p - y[s]) * (p - y[s]);
		++jout;
	}
	mse /= jout;

	// Calculate rsq
	float yAvg = 0;
	for (size_t i = 0; i < num_samples; ++i)
	{
		yAvg += y[i];
	}
	yAvg /= num_samples;
	float yVar = 0;
	for (size_t i = 0; i < num_samples; ++i)
	{
		yVar += (y[i] - yAvg) * (y[i] - yAvg);
	}
	rsq = 1 - mse * num_samples / yVar;
}

void forest::save(const string path) const
{
	ofstream ofs(path, ios::binary);
	save(ofs);
}

void forest::save(ofstream& ofs) const
{
	const unsigned int nt = size();
	ofs.write((char*)&nt, 4);
	for (const auto& t : *this)
	{
		t.save(ofs);
	}
}
