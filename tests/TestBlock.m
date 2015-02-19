function funcs = testBlock
%TESTFILE Tests for the nix.Block object
%   Detailed explanation goes here

    funcs{1} = @test_list_arrays;
    funcs{2} = @test_list_sources;
    funcs{3} = @test_list_tags;
    funcs{4} = @test_list_multitags;
    funcs{5} = @test_open_array;
    funcs{6} = @test_open_tag;
    funcs{7} = @test_open_multitag;
    funcs{8} = @test_open_source;
    funcs{9} = @test_has_multitag;
    funcs{10} = @test_has_tag;
    funcs{11} = @test_has_metadata;
    funcs{12} = @test_open_metadata;
end

function [] = test_list_arrays( varargin )
%% Test: List/fetch data arrays
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);

    assert(size(getBlock.list_data_arrays(),1) == 198);
    assert(size(getBlock.dataArrays,1) == 198);
end

function [] = test_list_sources( varargin )
%% Test: List/fetch sources
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);

    assert(size(getBlock.list_sources(),1) == 1);
    assert(size(getBlock.sources(), 1) == 1);
end

function [] = test_list_tags( varargin )
%% Test: List/fetch tags
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);

    assert(size(getBlock.list_tags(),1) == 198);
    assert(size(getBlock.tags(), 1) == 198);
end

function [] = test_list_multitags( varargin )
%% Test: List/fetch multitags
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);
    
    assert(size(getBlock.list_multi_tags(),1) == 99);
    assert(size(getBlock.multiTags(), 1) == 99);
end

function [] = test_open_array( varargin )
%% Test: Open data array by ID or name
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);

    getDataArrayByID = getBlock.data_array(getBlock.dataArrays{1,1}.id);
    assert(strcmp(getDataArrayByID.id, 'e0ca39b7-632f-47c9-968c-c65e6db58719'));

    getDataArrayByName = getBlock.data_array(getBlock.dataArrays{1,1}.name);
    assert(strcmp(getDataArrayByName.id, 'e0ca39b7-632f-47c9-968c-c65e6db58719'));
end

function [] = test_open_tag( varargin )
%% Test: Open tag by ID or name
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);    

    getTagByID = getBlock.open_tag(getBlock.tags{1,1}.id);
    assert(strcmp(getTagByID.id, 'f49f4a56-0c93-4323-8e37-4b02b8cabb55'));

    getTagByName = getBlock.open_tag(getBlock.tags{1,1}.name);
    assert(strcmp(getTagByName.id, 'f49f4a56-0c93-4323-8e37-4b02b8cabb55'));
end

function [] = test_open_multitag( varargin )
%% Test: Open multi tag by ID or name
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);    

    getMultiTagByID = getBlock.open_multi_tag(getBlock.multiTags{1,1}.id);
    assert(strcmp(getMultiTagByID.id, '9e3fdaa5-a71c-4be0-91b3-9c35ed2d4723'));

    getMultiTagByName = getBlock.open_multi_tag(getBlock.multiTags{1,1}.name);
    assert(strcmp(getMultiTagByName.id, '9e3fdaa5-a71c-4be0-91b3-9c35ed2d4723'));
end

function [] = test_open_source( varargin )
%% Test: Open source by ID or name
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);    

    getSourceByID = getBlock.open_source(getBlock.sources{1,1}.id);
    assert(strcmp(getSourceByID.id, 'edf4c8b6-8569-4952-bcee-4203dd26571e'));

    getSourceByName = getBlock.open_source(getBlock.sources{1,1}.name);
    assert(strcmp(getSourceByName.id, 'edf4c8b6-8569-4952-bcee-4203dd26571e'));
end

function [] = test_has_multitag( varargin )
%% Test: Block has multi tag by ID or name
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);    
    
    assert(getBlock.has_multi_tag(getBlock.multiTags{1,1}.id));
    assert(getBlock.has_multi_tag(getBlock.multiTags{1,1}.name));
end

function [] = test_has_tag( varargin )
%% Test: Block has tag by ID or name
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);

    assert(getBlock.has_tag(getBlock.tags{1,1}.id));
    assert(getBlock.has_tag(getBlock.tags{1,1}.name));
end

function [] = test_has_metadata( varargin )
%% Test: Has metadata
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);

    assert(~getBlock.has_metadata());
   
    %-- ToDo implement test for exising metadata
    %getBlock = test_file.openBlock(test_file.blocks{1,1}.name);
    %assert(getBlock.has_metadata())
end

function [] = test_open_metadata( varargin )
%% Test: Open metadata
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);

    assert(isempty(getBlock.open_metadata()))
    
    %-- ToDo implement test for exising metadata
    %getBlock = test_file.openBlock(test_file.blocks{1,1}.name);
    %assert(~isempty(getBlock.open_metadata()))
end