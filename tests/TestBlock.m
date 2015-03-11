function funcs = TestBlock
%TESTFILE Tests for the nix.Block object
%   Detailed explanation goes here

    funcs = {};
    funcs{end+1} = @test_list_arrays;
    funcs{end+1} = @test_list_sources;
    funcs{end+1} = @test_list_tags;
    funcs{end+1} = @test_list_multitags;
    funcs{end+1} = @test_open_array;
    funcs{end+1} = @test_open_tag;
    funcs{end+1} = @test_open_multitag;
    funcs{end+1} = @test_open_source;
    funcs{end+1} = @test_has_multitag;
    funcs{end+1} = @test_has_tag;
    funcs{end+1} = @test_open_metadata;
    funcs{end+1} = @test_attrs;
    funcs{end+1} = @test_create_data_array;
    funcs{end+1} = @test_create_data_array_from_data;
    funcs{end+1} = @test_delete_data_array;
    funcs{end+1} = @test_create_tag;
    funcs{end+1} = @test_delete_tag;
    funcs{end+1} = @test_create_multi_tag;
    funcs{end+1} = @test_delete_multi_tag;
    funcs{end+1} = @test_create_source;
    funcs{end+1} = @test_delete_source;
end

function [] = test_list_arrays( varargin )
%% Test: List/fetch data arrays
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);

    assert(size(getBlock.dataArrays,1) == 198);
end

function [] = test_list_sources( varargin )
%% Test: List/fetch sources
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);

    assert(size(getBlock.sources(), 1) == 1);
end

function [] = test_list_tags( varargin )
%% Test: List/fetch tags
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);

    assert(size(getBlock.tags(), 1) == 198);
end

function [] = test_list_multitags( varargin )
%% Test: List/fetch multitags
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);
    
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
    
    %-- test open non existing dataarray
    getDataArray = getBlock.data_array('I dont exist');
    assert(isempty(getDataArray));
end

function [] = test_open_tag( varargin )
%% Test: Open tag by ID or name
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);    

    getTagByID = getBlock.open_tag(getBlock.tags{1,1}.id);
    assert(strcmp(getTagByID.id, 'f49f4a56-0c93-4323-8e37-4b02b8cabb55'));

    getTagByName = getBlock.open_tag(getBlock.tags{1,1}.name);
    assert(strcmp(getTagByName.id, 'f49f4a56-0c93-4323-8e37-4b02b8cabb55'));
    
    %-- test open non existing tag
    getTag = getBlock.open_tag('I dont exist');
    assert(isempty(getTag));
end

function [] = test_open_multitag( varargin )
%% Test: Open multi tag by ID or name
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);    

    getMultiTagByID = getBlock.open_multi_tag(getBlock.multiTags{1,1}.id);
    assert(strcmp(getMultiTagByID.id, '9e3fdaa5-a71c-4be0-91b3-9c35ed2d4723'));

    getMultiTagByName = getBlock.open_multi_tag(getBlock.multiTags{1,1}.name);
    assert(strcmp(getMultiTagByName.id, '9e3fdaa5-a71c-4be0-91b3-9c35ed2d4723'));
    
    %-- test open non existing multitag
    getMultiTag = getBlock.open_multi_tag('I dont exist');
    assert(isempty(getMultiTag));
end

function [] = test_open_source( varargin )
%% Test: Open source by ID or name
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);    

    getSourceByID = getBlock.open_source(getBlock.sources{1,1}.id);
    assert(strcmp(getSourceByID.id, 'edf4c8b6-8569-4952-bcee-4203dd26571e'));

    getSourceByName = getBlock.open_source(getBlock.sources{1,1}.name);
    assert(strcmp(getSourceByName.id, 'edf4c8b6-8569-4952-bcee-4203dd26571e'));
    
    %-- test open non existing source
    getSource = getBlock.open_source('I dont exist');
    assert(isempty(getSource));
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

function [] = test_open_metadata( varargin )
%% Test: Open metadata
    test_file = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    getBlock = test_file.openBlock(test_file.blocks{1,1}.name);

    assert(isempty(getBlock.open_metadata()))
    
    %-- ToDo implement test for exising metadata
    %getBlock = test_file.openBlock(test_file.blocks{1,1}.name);
    %assert(~isempty(getBlock.open_metadata()))
end

function [] = test_attrs( varargin )
%% Test: Access Attributes
    f = nix.File(fullfile(pwd, 'tests', 'test.h5'), nix.FileMode.ReadOnly);
    b1 = f.blocks{1};

    assert(~isempty(b1.id));
    assert(strcmp(b1.name, 'joe097'));
    assert(strcmp(b1.type, 'nix.session'));
    assert(isempty(b1.definition));
end

function [] = test_create_tag( varargin )
%% Test: Create Tag
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('tagtest', 'nixblock');
    
    assert(isempty(b.tags));

    position = [1.0 1.2 1.3 15.9];
    t1 = b.create_tag('foo', 'bar', position);
    assert(strcmp(t1.name, 'foo'));
    assert(strcmp(t1.type, 'bar'));
    assert(isequal(t1.position, position));
    
    assert(~isempty(b.tags));
end

%% Test: delete tag by entity and id
function [] = test_delete_tag( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('tagtest', 'nixBlock');
    position = [1.0 1.2 1.3 15.9];
    tmp = b.create_tag('tagtest1', 'nixTag', position);
    tmp = b.create_tag('tagtest2', 'nixTag', position);
    
    assert(size(b.tags, 1) == 2);
    assert(b.delete_tag(b.tags{2}.id));
    assert(size(b.tags, 1) == 1);
    assert(b.delete_tag(b.tags{1}));
    assert(isempty(b.tags));

    assert(~b.delete_tag('I do not exist'));
end

function [] = test_create_data_array( varargin )
%% Test: Create Data Array
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('arraytest', 'nixblock');
    
    assert(isempty(b.dataArrays));
    
    d1 = b.create_data_array('foo', 'bar', 'double', [2 3]);

    assert(strcmp(d1.name, 'foo'));
    assert(strcmp(d1.type, 'bar'));
    tmp = d1.read_all();
    assert(all(tmp(:) == 0));
    
    assert(~isempty(b.dataArrays));
end

function [] = test_create_data_array_from_data( varargin )
%% Test: Create Data Array from data
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('arraytest', 'nixblock');
    
    assert(isempty(b.dataArrays));
    
    data = [1, 2, 3; 4, 5, 6];
    d1 = b.create_data_array_from_data('foo', 'bar', data);

    assert(strcmp(d1.name, 'foo'));
    assert(strcmp(d1.type, 'bar'));
    
    tmp = d1.read_all();
    assert(strcmp(class(tmp), class(data)));
    assert(isequal(size(tmp), size(data)));
    assert(isequal(tmp, data));
    
    assert(~isempty(b.dataArrays));
end

%% Test: delete dataArray by entity and id
function [] = test_delete_data_array( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('arraytest', 'nixBlock');
    tmp = b.create_data_array('dataArrayTest1', 'nixDataArray', 'double', [1 2]);
    tmp = b.create_data_array('dataArrayTest2', 'nixDataArray', 'double', [3 4]);
    
    assert(size(b.dataArrays, 1) == 2);
    assert(b.delete_data_array(b.dataArrays{2}.id));
    assert(size(b.dataArrays, 1) == 1);
    assert(b.delete_data_array(b.dataArrays{1}));
    assert(isempty(b.dataArrays));
    assert(~b.delete_data_array('I do not exist'));
end

function [] = test_create_multi_tag( varargin )
%% Test: Create multitag by data_array entity and data_array id
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('mTagTestBlock', 'nixBlock');
	tmp = b.create_data_array('mTagTestDataArray1', 'nixDataArray', 'double', [1 2]);
    tmp = b.create_data_array('mTagTestDataArray2', 'nixDataArray', 'double', [3 4]);
    assert(isempty(b.multiTags));

    %-- create by data_array entity
    tmp = b.create_multi_tag('mTagTest1', 'nixMultiTag1', b.dataArrays{1});
    assert(~isempty(b.multiTags));
    assert(strcmp(b.multiTags{1}.name, 'mTagTest1'));

    %-- create by data_array id
    tmp = b.create_multi_tag('mTagTest2', 'nixMultiTag2', b.dataArrays{2}.id);
    assert(size(b.multiTags, 1) == 2);
    assert(strcmp(b.multiTags{2}.type, 'nixMultiTag2'));
end

%% Test: delete multitag by entity and id
function [] = test_delete_multi_tag( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('mTagTestBlock', 'nixBlock');
	tmp = b.create_data_array('mTagTestDataArray1', 'nixDataArray', 'double', [1 2]);
    tmp = b.create_multi_tag('mTagTest1', 'nixMultiTag1', b.dataArrays{1});
    tmp = b.create_multi_tag('mTagTest2', 'nixMultiTag2', b.dataArrays{1});

    assert(size(b.multiTags, 1) == 2);
    assert(b.delete_multi_tag(b.multiTags{2}.id));
    assert(size(b.multiTags, 1) == 1);
    assert(b.delete_multi_tag(b.multiTags{1}));
    assert(isempty(b.multiTags));
    assert(size(b.dataArrays, 1) == 1);

    assert(~b.delete_multi_tag('I do not exist'));
end

%% Test: create source
function [] = test_create_source ( varargin )
    test_file = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    getBlock = test_file.createBlock('sourcetest', 'nixblock');
    assert(isempty(getBlock.sources));

    createSource = getBlock.create_source('sourcetest','nixsource');
    assert(~isempty(getBlock.sources));
    assert(strcmp(createSource.name, 'sourcetest'));
    assert(strcmp(createSource.type, 'nixsource'));
end

%% Test: delete source
function [] = test_delete_source( varargin )
    test_file = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    getBlock = test_file.createBlock('sourcetest', 'nixblock');
    createSource1 = getBlock.create_source('sourcetest1','nixsource');
    createSource2 = getBlock.create_source('sourcetest2','nixsource');

    assert(getBlock.delete_source('sourcetest1'));
    assert(getBlock.delete_source(getBlock.sources{1}.id));
    assert(~getBlock.delete_source('I do not exist'));
    assert(isempty(getBlock.sources));
end
