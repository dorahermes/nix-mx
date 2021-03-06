% TestSource provides tests for all supported nix.Source methods.
%
% Copyright (c) 2016, German Neuroinformatics Node (G-Node)
%
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted under the terms of the BSD License. See
% LICENSE file in the root of the Project.

function funcs = TestSource
    funcs = {};
    funcs{end+1} = @testCreateSource;
    funcs{end+1} = @testDeleteSource;
    funcs{end+1} = @testAttributes;
    funcs{end+1} = @testFetchSources;
    funcs{end+1} = @testHasSource;
    funcs{end+1} = @testOpenSource;
    funcs{end+1} = @testOpenSourceIdx;
    funcs{end+1} = @testSourceCount;
    funcs{end+1} = @testParentSource;
    funcs{end+1} = @testSetMetadata;
    funcs{end+1} = @testOpenMetadata;
    funcs{end+1} = @testReferringDataArrays;
    funcs{end+1} = @testReferringTags;
    funcs{end+1} = @testReferringMultiTags;
    funcs{end+1} = @testCompare;
    funcs{end+1} = @testFilterSource;
    funcs{end+1} = @testFindSource;
    funcs{end+1} = @testFilterFindSource;
end

%% Test: Fetch Sources
function [] = testFetchSources( varargin )
    fileName = fullfile(pwd, 'tests', 'testRW.h5');
    f = nix.File(fileName, nix.FileMode.Overwrite);
    b = f.createBlock('sourcetest', 'nixBlock');
    s = b.createSource('sourcetest', 'nixSource');

    assert(isempty(s.sources));
    assert(isempty(f.blocks{1}.sources{1}.sources));
    tmp = s.createSource('nestedsource1', 'nixSource');
    assert(size(s.sources, 1) == 1);
    assert(size(f.blocks{1}.sources{1}.sources, 1) == 1);
    tmp = s.createSource('nestedsource2', 'nixSource');
    assert(size(s.sources, 1) == 2);
    assert(size(f.blocks{1}.sources{1}.sources, 1) == 2);
    
    clear tmp s b f;
    f = nix.File(fileName, nix.FileMode.ReadOnly);
    assert(size(f.blocks{1}.sources{1}.sources, 1) == 2);
end

%% Test: Open Source by id or name
function [] = testOpenSource( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('sourcetest', 'nixBlock');
    s = b.createSource('sourcetest', 'nixSource');
    assert(isempty(s.sources));

    sourceName = 'nestedsource';
    createSource = s.createSource(sourceName, 'nixSource');
    getSourceByID = s.openSource(createSource.id);
    assert(~isempty(getSourceByID));

    getSourceByName = s.openSource(sourceName);
    assert(~isempty(getSourceByName));

    %-- test open non existing source
    getNonSource = s.openSource('I dont exist');
    assert(isempty(getNonSource));
end

%% Test Open Source by index
function [] = testOpenSourceIdx( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('testBlock', 'nixBlock');
    s = b.createSource('testSource', 'nixSource');
    s1 = s.createSource('testSource1', 'nixSource');
    s2 = s.createSource('testSource2', 'nixSource');
    s3 = s.createSource('testSource3', 'nixSource');

    assert(strcmp(f.blocks{1}.sources{1}.openSourceIdx(1).name, s1.name));
    assert(strcmp(f.blocks{1}.sources{1}.openSourceIdx(2).name, s2.name));
    assert(strcmp(f.blocks{1}.sources{1}.openSourceIdx(3).name, s3.name));
end

%% Test: Source count
function [] = testSourceCount( varargin )
    testFile = fullfile(pwd, 'tests', 'testRW.h5');
    f = nix.File(testFile, nix.FileMode.Overwrite);
    b = f.createBlock('testBlock', 'nixBlock');
    s = b.createSource('testSource', 'nixSource');

    assert(s.sourceCount() == 0);
    s.createSource('testSource1', 'nixSource');
    assert(s.sourceCount() == 1);
    s.createSource('testSource2', 'nixSource');

    clear s b f;
    f = nix.File(testFile, nix.FileMode.ReadOnly);
    assert(f.blocks{1}.sources{1}.sourceCount() == 2);
end

%% Test: Set metadata
function [] = testSetMetadata ( varargin )
    fileName = fullfile(pwd, 'tests', 'testRW.h5');
    secName1 = 'testSection1';
    secName2 = 'testSection2';
    f = nix.File(fileName, nix.FileMode.Overwrite);
    tmp = f.createSection('testSection1', 'nixSection');
    tmp = f.createSection('testSection2', 'nixSection');
    b = f.createBlock('testBlock', 'nixBlock');
    s = b.createSource('testSource', 'nixSource');

    assert(isempty(s.openMetadata));
    assert(isempty(f.blocks{1}.sources{1}.openMetadata));

    s.setMetadata(f.sections{1});
    assert(strcmp(s.openMetadata.name, secName1));
    assert(strcmp(f.blocks{1}.sources{1}.openMetadata.name, secName1));

    s.setMetadata(f.sections{2});
    assert(strcmp(s.openMetadata.name, secName2));
    assert(strcmp(f.blocks{1}.sources{1}.openMetadata.name, secName2));

    s.setMetadata('');
    assert(isempty(s.openMetadata));
    assert(isempty(f.blocks{1}.sources{1}.openMetadata));

	s.setMetadata(f.sections{2});
    clear tmp b f;
    f = nix.File(fileName, nix.FileMode.ReadOnly);
    assert(strcmp(f.blocks{1}.sources{1}.openMetadata.name, secName2));
end

%% Test: Open metadata
function [] = testOpenMetadata( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    tmp = f.createSection('testSection', 'nixSection');
    b = f.createBlock('testBlock', 'nixBlock');
    s = b.createSource('testSource', 'nixSource');
    s.setMetadata(f.sections{1});

    assert(strcmp(s.openMetadata.name, 'testSection'));
end

%% Test: Create Source
function [] = testCreateSource ( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('sourcetest', 'nixBlock');
    s = b.createSource('sourcetest', 'nixSource');
    assert(isempty(s.sources));

    createSource = s.createSource('nestedsource', 'nixSource');
    assert(~isempty(s.sources));
    assert(strcmp(createSource.name, 'nestedsource'));
    assert(strcmp(createSource.type, 'nixSource'));
end

%% Test: Delete Source by id, name and entity
function [] = testDeleteSource( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('sourcetest', 'nixBlock');
    s = b.createSource('sourcetest', 'nixSource');
    assert(isempty(s.sources));

    tmp = s.createSource('nestedsource1', 'nixSource');
    tmp = s.createSource('nestedsource2', 'nixSource');
    tmp = s.createSource('nestedsource3', 'nixSource');
    assert(s.deleteSource(s.sources{3}.id));
    assert(s.deleteSource(s.sources{2}.name));
    assert(s.deleteSource(s.sources{1}));
    assert(~s.deleteSource('I do not exist'));
    assert(isempty(s.sources));
end

%% Test: Access Attributes
function [] = testAttributes( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('tagtest', 'test nixBlock');
    s = b.createSource('sourcetest', 'test nixSource');

    assert(~isempty(s.id));
    assert(strcmp(s.name, 'sourcetest'));
    assert(strcmp(s.type, 'test nixSource'));
    
    s.type = 'nixSource';
    assert(strcmp(s.type, 'nixSource'));
    
    assert(isempty(s.definition));
    s.definition = 'source definition';
    assert(strcmp(s.definition, 'source definition'));

    s.definition = '';
    assert(isempty(s.definition));
end

%% Test: Has Source by id and name
function [] = testHasSource( varargin )
    fileName = 'testRW.h5';
    sName = 'nestedsource';
    f = nix.File(fullfile(pwd, 'tests', fileName), nix.FileMode.Overwrite);
    b = f.createBlock('testblock', 'nixBlock');
    s = b.createSource('sourcetest', 'nixSource');
    nested = s.createSource(sName, 'nixSource');
    nestedID = nested.id;

    assert(~s.hasSource('I do not exist'));
    assert(s.hasSource(sName));

    clear nested s b f;
    f = nix.File(fullfile(pwd, 'tests', fileName), nix.FileMode.ReadOnly);
    assert(f.blocks{1}.sources{1}.hasSource(nestedID));
end

%% Test: Get parent Source
function [] = testParentSource( varargin )
    fileName = fullfile(pwd, 'tests', 'testRW.h5');
    f = nix.File(fileName, nix.FileMode.Overwrite);
    b = f.createBlock('sourcetest', 'nixBlock');
    sourceName1 = 'testSource1';
    sourceName2 = 'testSource2';
    s1 = b.createSource(sourceName1, 'nixSource');
    s2 = s1.createSource(sourceName2, 'nixSource');
    s3 = s2.createSource('testSource3', 'nixSource');

    assert(strcmp(s3.parentSource.name, sourceName2));
    assert(strcmp(s2.parentSource.name, sourceName1));
    assert(isempty(s1.parentSource));
end

%% Test: Referring DataArrays
function [] = testReferringDataArrays( varargin )
    fileName = fullfile(pwd, 'tests', 'testRW.h5');
    f = nix.File(fileName, nix.FileMode.Overwrite);
    b = f.createBlock('testBlock', 'nixBlock');
    s = b.createSource('testSource', 'nixSource');

    assert(isempty(s.referringDataArrays));

    d1 = b.createDataArray('testDataArray1', 'nixDataArray', nix.DataType.Double, [1 2]);
    d1.addSource(s);
    assert(~isempty(s.referringDataArrays));
    assert(strcmp(s.referringDataArrays{1}.name, d1.name));

    d2 = b.createDataArray('testDataArray2', 'nixDataArray', nix.DataType.Double, [1 2]);
    d2.addSource(s);
    assert(size(s.referringDataArrays, 1) == 2);
end

%% Test: Referring Tags
function [] = testReferringTags( varargin )
    fileName = fullfile(pwd, 'tests', 'testRW.h5');
    f = nix.File(fileName, nix.FileMode.Overwrite);
    b = f.createBlock('testBlock', 'nixBlock');
    s = b.createSource('testSource', 'nixSource');

    assert(isempty(s.referringTags));

    t1 = b.createTag('testTag1', 'nixTag', [1, 2]);
    t1.addSource(s);
    assert(~isempty(s.referringTags));
    assert(strcmp(s.referringTags{1}.name, t1.name));

    t2 = b.createTag('testTag2', 'nixTag', [1, 2]);
    t2.addSource(s);
    assert(size(s.referringTags, 1) == 2);
end

%% Test: Referring MultiTags
function [] = testReferringMultiTags( varargin )
    fileName = fullfile(pwd, 'tests', 'testRW.h5');
    f = nix.File(fileName, nix.FileMode.Overwrite);
    b = f.createBlock('testBlock', 'nixBlock');
    d = b.createDataArray('testDataArray', 'nixDataArray', nix.DataType.Double, [1 2]);
    s = b.createSource('testSource', 'nixSource');

    assert(isempty(s.referringMultiTags));

    t1 = b.createMultiTag('testMultiTag1', 'nixMultiTag', d);
    t1.addSource(s);
    assert(~isempty(s.referringMultiTags));
    assert(strcmp(s.referringMultiTags{1}.name, t1.name));

    t2 = b.createMultiTag('testMultiTag2', 'nixMultiTag', d);
    t2.addSource(s);
    assert(size(s.referringMultiTags, 1) == 2);
end

%% Test: Compare Source entities
function [] = testCompare( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b1 = f.createBlock('testBlock1', 'nixBlock');
    b2 = f.createBlock('testBlock2', 'nixBlock');
    s1 = b1.createSource('testSource1', 'nixSource');
    s2 = b1.createSource('testSource2', 'nixSource');
    s3 = b2.createSource('testSource1', 'nixSource');

    assert(s1.compare(s2) < 0);
    assert(s1.compare(s1) == 0);
    assert(s2.compare(s1) > 0);
    assert(s1.compare(s3) ~= 0);
end

%% Test: Filter Sources
function [] = testFilterSource( varargin )
    filterName = 'filterMe';
    filterType = 'filterType';
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('testBlock', 'nixBlock');
    ms = b.createSource('testSource', 'nixSource');
    s = ms.createSource(filterName, 'nixSource');
    filterID = s.id;
	s = ms.createSource('testSource1', filterType);
    filterIDs = {filterID, s.id};
    s = ms.createSource('testSource2', filterType);

    % test empty id filter
    assert(isempty(f.blocks{1}.sources{1}.filterSources(nix.Filter.id, 'IdoNotExist')));

    % test nix.Filter.acceptall
    filtered = f.blocks{1}.sources{1}.filterSources(nix.Filter.acceptall, '');
    assert(size(filtered, 1) == 3);

    % test nix.Filter.id
    filtered = f.blocks{1}.sources{1}.filterSources(nix.Filter.id, filterID);
    assert(size(filtered, 1) == 1);
    assert(strcmp(filtered{1}.id, filterID));

    % test nix.Filter.ids
    filtered = f.blocks{1}.sources{1}.filterSources(nix.Filter.ids, filterIDs);
    assert(size(filtered, 1) == 2);
    assert(strcmp(filtered{1}.id, filterIDs{1}) || strcmp(filtered{1}.id, filterIDs{2}));
    
    % test nix.Filter.name
    filtered  = f.blocks{1}.sources{1}.filterSources(nix.Filter.name, filterName);
    assert(size(filtered, 1) == 1);
    assert(strcmp(filtered{1}.name, filterName));
    
    % test nix.Filter.type
    filtered = f.blocks{1}.sources{1}.filterSources(nix.Filter.type, filterType);
    assert(size(filtered, 1) == 2);

    % test nix.Filter.metadata
    mainName = 'testSubSection';
    mainSource = ms.createSource(mainName, 'nixSource');
    subName = 'testSubSection1';
    s = f.createSection(subName, 'nixSection');
    mainSource.setMetadata(s);
    subID = s.id;

    assert(isempty(f.blocks{1}.sources{1}.filterSources(nix.Filter.metadata, 'Do not exist')));
    filtered = f.blocks{1}.sources{1}.filterSources(nix.Filter.metadata, subID);
    assert(size(filtered, 1) == 1);
    assert(strcmp(filtered{1}.name, mainName));

    % test nix.Filter.source
    mainName = 'testSubSource';
    main = ms.createSource(mainName, 'nixSource');
    mainID = main.id;
    subName = 'testSubSource1';
    s = main.createSource(subName, 'nixSource');
    subID = s.id;

    assert(isempty(f.blocks{1}.sources{1}.filterSources(nix.Filter.source, 'Do not exist')));
    filtered = f.blocks{1}.sources{1}.filterSources(nix.Filter.source, subName);
    assert(size(filtered, 1) == 1);
    assert(strcmp(filtered{1}.id, mainID));

    filtered = f.blocks{1}.sources{1}.filterSources(nix.Filter.source, subID);
    assert(size(filtered, 1) == 1);
    assert(strcmp(filtered{1}.name, mainName));
end

%% Test: Find Source w/o filter
function [] = testFindSource( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('testBlock', 'nixBlock');
    s = b.createSource('mainSource', 'nixSource');
    sl1 = s.createSource('sourceLvl1', 'nixSource');

    sl21 = sl1.createSource('sourceLvl2_1', 'nixSource');
    sl22 = sl1.createSource('sourceLvl2_2', 'nixSource');

    sl31 = sl21.createSource('sourceLvl3_1', 'nixSource');
    sl32 = sl21.createSource('sourceLvl3_2', 'nixSource');
    sl33 = sl21.createSource('sourceLvl3_3', 'nixSource');

    sl41 = sl31.createSource('sourceLvl4_1', 'nixSource');
    sl42 = sl31.createSource('sourceLvl4_2', 'nixSource');
    sl43 = sl31.createSource('sourceLvl4_3', 'nixSource');
    sl44 = sl31.createSource('sourceLvl4_4', 'nixSource');

    % Check invalid entry
    err = 'Provide a valid search depth';
    try
        s.findSources('hurra');
    catch ME
        assert(strcmp(ME.message, err));
    end

    % find all
    filtered = s.findSources(4);
    assert(size(filtered, 1) == 11);

    % find until level 3
    filtered = s.findSources(3);
    assert(size(filtered, 1) == 7);

    % find until level 2
    filtered = s.findSources(2);
    assert(size(filtered, 1) == 4);

    % find until level 1
    filtered = s.findSources(1);
    assert(size(filtered, 1) == 2);

    % find until level 0
    filtered = s.findSources(0);
    assert(size(filtered, 1) == 1);
end

%% Test: Find Sources with filters
function [] = testFilterFindSource( varargin )
    findSource = 'nixFindSource';
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('testBlock', 'nixBlock');
    s = b.createSource('mainSource', 'nixSource');
    sl1 = s.createSource('sourceLvl1', 'nixSource');

    sl21 = sl1.createSource('sourceLvl2_1', 'nixSource');
    sl22 = sl1.createSource('sourceLvl2_2', findSource);

    sl31 = sl21.createSource('sourceLvl3_1', findSource);
    sl32 = sl21.createSource('sourceLvl3_2', 'nixSource');
    sl33 = sl21.createSource('sourceLvl3_3', 'nixSource');

    sl41 = sl31.createSource('sourceLvl4_1', 'nixSource');
    sl42 = sl31.createSource('sourceLvl4_2', 'nixSource');
    sl43 = sl31.createSource('sourceLvl4_3', findSource);
    sl44 = sl31.createSource('sourceLvl4_4', 'nixSource');

    % test find by id
    filtered = s.filterFindSources(1, nix.Filter.id, sl41.id);
    assert(isempty(filtered));
    filtered = s.filterFindSources(5, nix.Filter.id, sl41.id);
    assert(size(filtered, 1) == 1);
    assert(strcmp(filtered{1}.id, sl41.id));

    % test find by ids
    filterids = {sl1.id, sl41.id};
    filtered = s.filterFindSources(2, nix.Filter.ids, filterids);
    assert(size(filtered, 1) == 1);
    filtered = s.filterFindSources(5, nix.Filter.ids, filterids);
    assert(size(filtered, 1) == 2);

    % test find by name
    filtered = s.filterFindSources(1, nix.Filter.name, sl41.name);
    assert(isempty(filtered));
    filtered = s.filterFindSources(5, nix.Filter.name, sl41.name);
    assert(size(filtered, 1) == 1);
    assert(strcmp(filtered{1}.name, sl41.name));

    % test find by type
    filtered = s.filterFindSources(1, nix.Filter.type, findSource);
    assert(isempty(filtered));
    filtered = s.filterFindSources(5, nix.Filter.type, findSource);
    assert(size(filtered, 1) == 3);
    assert(strcmp(filtered{1}.type, findSource));

    % test nix.Filter.metadata
    sec = f.createSection('testSection', 'nixSection');
    sl43.setMetadata(sec);
    filtered = s.filterFindSources(1, nix.Filter.metadata, sec.id);
    assert(isempty(filtered));
    filtered = s.filterFindSources(5, nix.Filter.metadata, sec.id);
    assert(size(filtered, 1) == 1);
    strcmp(filtered{1}.id, sl43.id);

    % test nix.Filter.source
    filtered = s.filterFindSources(1, nix.Filter.source, sl44.id);
    assert(isempty(filtered));
    filtered = s.filterFindSources(5, nix.Filter.source, sl44.id);
    assert(size(filtered, 1) == 1);
    assert(strcmp(filtered{1}.id, sl31.id));
end
