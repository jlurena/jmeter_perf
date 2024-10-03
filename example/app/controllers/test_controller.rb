class TestController < ApplicationController
  def fast
    render plain: "Fast action"
  end

  def slow
    sleep 5
    render plain: "Slow action"
  end

  def random
    sleep rand(1..3)
    render plain: "Random"
  end
end
