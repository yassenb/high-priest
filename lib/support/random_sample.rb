module Support
module_function

  def random_sample(arr, n=1, allow_repetitions=true)
    return arr.sample if n == 1
    (allow_repetitions ? (arr * n) : arr).sample n
  end
end
