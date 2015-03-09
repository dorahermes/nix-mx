function funcs = testSource
%TESTSOURCE tests for Source
%   Detailed explanation goes here

    funcs = {};
    funcs{end+1} = @test_list_fetch_sources;
    funcs{end+1} = @test_open_source;
    funcs{end+1} = @test_open_metadata;
end

%% Test: List/fetch sources
function [] = test_list_fetch_sources( varargin )
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.id);
    getSourceFromBlock = getBlock.open_source(getBlock.sources{1,1}.id);

    %-- TODO: get a testfile with nested sources
    assert(size(getSourceFromBlock.sources(), 1) == 0);
    disp('Test Source: fetch sources ... TODO (proper testfile)');
end

%% Test: Open source by ID or name
function [] = test_open_source( varargin )
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.id);
    getSFromB = getBlock.open_source(getBlock.sources{1,1}.id);
    
    %-- TODO: comment in, when testfile with nested sources is available
    %getSourceByID = getSFromB.open_source(getSFromB.sources{1,1}.id);
    %assert(strcmp(getSourceByID.id, ''));
    disp('Test Source: open source by ID ... TODO (proper testfile)');

    %getSourceByName = getSFromB.open_source(getSFromB.sources{1,1}.name);
    %assert(strcmp(getSourceByName.id, ''));
    disp('Test Source: open source by name ... TODO (proper testfile)');
    
    %-- test open non existing source
    getSource = getSFromB.open_source('I dont exist');
    assert(isempty(getSource));
end

%% Test: Open metadata
function [] = test_open_metadata( varargin )
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);
    
    getSource = getBlock.open_source(getBlock.sources{1,1}.id);
    assert(isempty(getSource.open_metadata()))
    
    %-- ToDo implement test for empty metadata
    %getSource = getBlock.open_source(getBlock.sources{1,1}.id);
    %assert(~isempty(getSource.open_metadata()))
    disp('Test Source: open existing metadata ... TODO (proper testfile)');
end

