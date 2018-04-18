$LOAD_PATH.unshift File.expand_path('../../../sort', __FILE__)
require 'sort'

describe Array do

  it 'is insertion sort' do
    array = [1,2,3,4,6,7,8,10,11,12,13,15,5,9,14,16,17,18,19,20]

    # ascending
    expect(array.insertion_sort).to eq array.sort
    expect(array.insertion_sort{|a, b| a <=> b}).to eq array.sort{|a, b| a <=> b}

    # descending
    expect(array.insertion_sort{|a, b| b <=> a}).to eq array.sort{|a, b| b <=> a}
  end

  it 'is merge sort' do
    array = [1,2,3,4,6,7,8,10,11,12,13,15,5,9,14,16,17,18,19,20]

    # ascending
    expect(array.merge_sort).to eq array.sort
    expect(array.merge_sort{|a, b| a <=> b}).to eq array.sort{|a, b| a <=> b}

    # descending
    expect(array.merge_sort{|a, b| b <=> a}).to eq array.sort{|a, b| b <=> a}
  end

end
