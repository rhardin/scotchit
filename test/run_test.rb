require "minitest/autorun"

require "scotchit"

class StatsTest < Minitest::Unit::TestCase #Minitest::Test
    def test_ci
        assert_equal 0.6656067501944406, Scotchit.ci_lower_bound(10, 10, 0.975)
    end

    def test_parse
        Scotchit.parse_csv("lib/ratings.csv")
        assert Scotchit::DB.has_key?("Ardbeg Uigeadail")
    end

    def test_score
        Scotchit.parse_csv("lib/ratings.csv")
        Scotchit.score()
        assert Scotchit::Stats.has_key?("Ardbeg Uigeadail")
        assert Scotchit::Price.has_key?("Ardbeg Uigeadail")
    end
end
