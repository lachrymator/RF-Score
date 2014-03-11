#pragma once
#ifndef RF_SCORE_FEATURE_HPP
#define RF_SCORE_FEATURE_HPP

#include "receptor.hpp"
#include "ligand.hpp"

vector<float> feature(const receptor& rec, const ligand& lig);

#endif
