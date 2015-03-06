function funcs = TestDataArray
%TESTDATAARRAY tests for DataArray
%   Detailed explanation goes here

    funcs = {};
    funcs{end+1} = @test_open_data;
    funcs{end+1} = @test_open_metadata;
    funcs{end+1} = @test_list_sources;
    funcs{end+1} = @test_set_data;
end

%% Test: Read all data from DataArray
function [] = test_open_data( varargin )
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);
    getDataArray = getBlock.data_array(getBlock.dataArrays{1,1}.id);

    assert(size(getDataArray.read_all(),2) == 36);
end

%% Test: Open metadata
function [] = test_open_metadata( varargin )
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);
    
    %-- ToDo implement test for empty metadata
    getDataArray = getBlock.data_array(getBlock.dataArrays{1,1}.id);
    %assert(isempty(getDataArray.open_metadata()))
    disp('Test DataArray: open empty metadata ... TODO (proper testfile)');
    
    getDataArray = getBlock.data_array(getBlock.dataArrays{1,1}.id);
    assert(~isempty(getDataArray.open_metadata()))
end

%% Test: List sources
function [] = test_list_sources( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    b = f.blocks{1};
    d1 = b.dataArrays{1};

    assert(~isempty(d1.sources));
    assert(strcmp(d1.sources{1}.name, 'Unit 5'));
end

%% Test: Set Data
function [] = test_set_data( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('tagtest', 'nixblock');

    d1 = b.create_data_array('foo', 'bar', 'double', [2 3]);
    tmp = d1.read_all();
    assert(all(tmp(:) == 0));
    
    data = [1, 2, 3; 4, 5, 6];
    d1.write_all(data);
    assert(isequal(d1.read_all(), data));
end

