class Array

  ##
  # Insertion sort
  # O(n^2)
  def insertion_sort!(&block)
    return self if self.size <= 1

    for i in 1...self.size do
      j = i
      while j > 0 && ((block)? block.call(self[j-1], self[j]) : self[j-1] <=> self[j]) > 0
        __swap__(j-1, j)
        j -= 1
      end
    end

    self
  end

  def insertion_sort(&block)
    self.dup.insertion_sort!(&block)
  end

  ##
  # Merge sort
  # O(n log n)
  def merge_sort(&block)
    return self if self.size <= 1

    __merge_sort__(self, &block)
  end

  def __merge_sort__(array, &block)
    return array if array.size <= 1

    mid = array.size / 2
    __merge__(__merge_sort__(array.slice(0, mid), &block), __merge_sort__(array.slice(mid, array.size), &block), &block)
  end

  def __merge__(left, right, &block)
    sorted_array = []

    until left.empty? || right.empty?
      if ((block)? block.call(left.first, right.first) : left.first <=> right.first) < 0
        sorted_array << left.shift
      else
        sorted_array << right.shift
      end
    end

    sorted_array + left + right
  end

private
  def __swap__(i, j)
    tmp = self[i]
    self[i] = self[j]
    self[j] = tmp
  end
end
