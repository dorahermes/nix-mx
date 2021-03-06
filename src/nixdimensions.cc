// Copyright (c) 2016, German Neuroinformatics Node (G-Node)
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted under the terms of the BSD License. See
// LICENSE file in the root of the Project.

#include <nix.hpp>
#include "mex.h"
#include "arguments.h"
#include "struct.h"

namespace nixdimensions {

    mxArray *describe(const nix::SetDimension &dim)
    {
        struct_builder sb({ 1 }, { "dimensionType", "labels" });

        sb.set(dim.dimensionType());
        sb.set(dim.labels());

        return sb.array();
    }

    mxArray *describe(const nix::SampledDimension &dim)
    {
        struct_builder sb({ 1 }, { "dimensionType", "label", "unit", "samplingInterval", "offset" });

        sb.set(dim.dimensionType());
        sb.set(dim.label());
        sb.set(dim.unit());
        sb.set(dim.samplingInterval());
        sb.set(dim.offset());

        return sb.array();
    }

    mxArray *describe(const nix::RangeDimension &dim)
    {
        struct_builder sb({ 1 }, { "dimensionType", "isAlias", "label", "unit", "ticks" });

        sb.set(dim.dimensionType());
        sb.set(dim.alias());
        sb.set(dim.label());
        sb.set(dim.unit());
        sb.set(dim.ticks());

        return sb.array();
    }

    void sampledPositionAt(const extractor &input, infusor &output) {
        nix::SampledDimension dim = input.entity<nix::SampledDimension>(1);
        const size_t index = static_cast<size_t>(input.num<double>(2));

        double pos = dim.positionAt(index);
        output.set(0, pos);
    }

    void sampledAxis(const extractor &input, infusor &output) {
        nix::SampledDimension dim = input.entity<nix::SampledDimension>(1);
        const size_t count = static_cast<size_t>(input.num<double>(2));
        const size_t startIndex = static_cast<size_t>(input.num<double>(3));

        std::vector<double> a = dim.axis(count, startIndex);
        mxArray *axis = mxCreateDoubleMatrix(1, a.size(), mxREAL);
        std::copy(a.begin(), a.end(), mxGetPr(axis));

        output.set(0, axis);
    }

    void sampledIndexOf(const extractor &input, infusor &output) {
        nix::SampledDimension dim = input.entity<nix::SampledDimension>(1);
        const double value = static_cast<double>(input.num<double>(2));

        size_t index = dim.indexOf(value);

        output.set(0, index);
    }

    void rangeTickAt(const extractor &input, infusor &output) {
        nix::RangeDimension dim = input.entity<nix::RangeDimension>(1);
        const size_t index = static_cast<size_t>(input.num<double>(2));

        double tick = dim.tickAt(index);
        output.set(0, tick);
    }

    void rangeAxis(const extractor &input, infusor &output) {
        nix::RangeDimension dim = input.entity<nix::RangeDimension>(1);
        const size_t count = static_cast<size_t>(input.num<double>(2));
        const size_t startIndex = static_cast<size_t>(input.num<double>(3));

        std::vector<double> a = dim.axis(count, startIndex);
        mxArray *axis = mxCreateDoubleMatrix(1, a.size(), mxREAL);
        std::copy(a.begin(), a.end(), mxGetPr(axis));

        output.set(0, axis);
    }

    void rangeIndexOf(const extractor &input, infusor &output) {
        nix::RangeDimension dim = input.entity<nix::RangeDimension>(1);
        const double value = static_cast<double>(input.num<double>(2));

        size_t index = dim.indexOf(value);

        output.set(0, index);
    }

} // namespace nixdimensions
