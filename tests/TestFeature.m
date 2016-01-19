function funcs = TestFeature
%TESTTag tests for Tag
%   Detailed explanation goes here

    funcs = {};
    funcs{end+1} = @test_open_data;
    funcs{end+1} = @test_get_set_link_type;
    funcs{end+1} = @test_set_data;
end

%% Test: Open data from feature
function [] = test_open_data ( varargin )
    f = nix.File(fullfile(pwd, 'tests', 'testRW.h5'), nix.FileMode.Overwrite);
    b = f.createBlock('featureTest', 'nixBlock');
    tmp = b.create_data_array('featureTestDataArray', 'nixDataArray', nix.DataType.Double, [1 2 3 4 5 6]);
    getTag = b.create_tag('featureTest', 'nixTag', [1, 2]);
    tmp = getTag.add_feature(b.dataArrays{1}, nix.LinkType.Tagged);
    
    getFeature = getTag.features{1};
    assert(~isempty(getFeature.open_data));
end

%% Test: Get and set nix.LinkType
function [] = test_get_set_link_type ( varargin )
    fileName = 'testRW.h5';
    f = nix.File(fullfile(pwd, 'tests', fileName), nix.FileMode.Overwrite);
    b = f.createBlock('featureTest', 'nixBlock');
    da = b.create_data_array('featureTestDataArray', 'nixDataArray', nix.DataType.Double, [1 2 3 4 5 6]);
    t = b.create_tag('featureTest', 'nixTag', [1, 2]);
    feat = t.add_feature(b.dataArrays{1}, nix.LinkType.Tagged);
    
    try
        feat.linkType = '';
    catch ME
        assert(strcmp(ME.identifier, 'nix:arg:inval'));
    end;
    try
        feat.linkType = {};
    catch ME
        assert(strcmp(ME.identifier, 'nix:arg:inval'));
    end;
    try
        feat.linkType = 1;
    catch ME
        assert(strcmp(ME.identifier, 'nix:arg:inval'));
    end;
    assert(f.blocks{1}.tags{1}.features{1}.linkType == 0);

    feat.linkType = nix.LinkType.Untagged;
    assert(f.blocks{1}.tags{1}.features{1}.linkType == 1);

    feat.linkType = nix.LinkType.Indexed;
    
    clear feat t da b f;
    f = nix.File(fullfile(pwd, 'tests', fileName), nix.FileMode.ReadOnly);
    assert(f.blocks{1}.tags{1}.features{1}.linkType == 2);
end

%% Test: Set data by entity, ID and name
function [] = test_set_data ( varargin )
    fileName = 'testRW.h5';
    daName1 = 'featTestDA1';
    daName2 = 'featTestDA2';
    daName3 = 'featTestDA3';
    daName4 = 'featTestDA4';
    daType = 'nixDataArray';
    daData = [1 2 3 4 5 6];
    f = nix.File(fullfile(pwd, 'tests', fileName), nix.FileMode.Overwrite);
    b = f.createBlock('featureTest', 'nixBlock');
    da1 = b.create_data_array(daName1, daType, nix.DataType.Double, daData);
    da2 = b.create_data_array(daName2, daType, nix.DataType.Double, daData);
    da3 = b.create_data_array(daName3, daType, nix.DataType.Double, daData);
    da4 = b.create_data_array(daName4, daType, nix.DataType.Double, daData);
    t = b.create_tag('featureTest', 'nixTag', [1, 2]);
    feat = t.add_feature(b.dataArrays{1}, nix.LinkType.Tagged);
    
    assert(strcmp(feat.open_data.name, daName1));
    feat.set_data(da2);
    assert(strcmp(f.blocks{1}.tags{1}.features{1}.open_data.name, daName2));
    feat.set_data(da3.id);
    assert(strcmp(f.blocks{1}.tags{1}.features{1}.open_data.name, daName3));
    feat.set_data(da4.name);
    
    clear feat t da4 da3 da2 da1 b f;
    f = nix.File(fullfile(pwd, 'tests', fileName), nix.FileMode.ReadOnly);
    assert(strcmp(f.blocks{1}.tags{1}.features{1}.open_data.name, daName4));
end
