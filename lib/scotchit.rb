# ruby scotchit.rb
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
require 'scotchit/version'
require 'csv'
require 'statistics2'

module Scotchit
    #
    # seeding the hashes
    DB = {}
    Stats = {}
    Price = {}
    #
    # In order with the philosophy of reddit, this program evaluates the ratings that
    # redditors have given to all of the whiskys submitted to review by executing a
    # Wilson Score confidence interval (lower bound). This is the same algroithm that
    # reddit users interally for ratings and thus what you see when you visit the site.
    #
    # Evan Miller's Wilson Score Interval fn
    def ci_lower_bound(pos, n, confidence)
        if n == 0
            return 0
        end
        z = Statistics2.pnormaldist(1-(1-confidence)/2)
        phat = 1.0*pos/n
        (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
    end
    module_function :ci_lower_bound
    #
    # grok the ratings.csv file
    def parse_csv(file_name)
        CSV.foreach(file_name, headers:true) do |row|
            # ignore non-Scotch things
            if %w[Bourbon Rye Grain Tennessee Liqueur Wheat].include? row['Region']
                next
            end
            # clean up key name
            name = row["Whisky Name"].strip
            # get the rating as an integer
            val = row['Rating'].to_i
            # get the cost as a floating point by removing non-digits and throwing out
            # un-american funny money
            if !%w[£ CDN CAD AUD € GBP NZD EUR CAN].any? {|x| row['Price'].to_s.upcase.include? x} #ugly
                cost = row['Price'].to_s.gsub(/[^\d\.]/, '').to_f
            else
                cost = 0.0
            end
            # seed key:val
            if !DB.has_key?(name)
                DB[name] = []
                Price[name] = []
            end
            # append score
            DB[name] << ((val == nil) ? 0 : val)
            if cost > 20.0
                Price[name] << cost
            end
        end
    end
    module_function :parse_csv
    #
    # do the confidence interval computations for all scotches meeting our thresholds.
    def score()
        DB.keys.each do |k|
            if DB[k].count > 5 # only eval whisky that has 6 or more reviews on reddit
                pos = DB[k].count {|x| x > 90 } # threshold as positive vote 91+% rating
                # calculate the Price indicator
                average = (Price[k] != []) ? Price[k].reduce(:+) / Price[k].count : 0.0
                indicator = case average.round(0)
                when 0 then "?"
                when 1..39 then "$"
                when 40..69 then "$$"
                when 70..89 then "$$$"
                when 90..120 then "$$$$"
                else
                    "$$$$$"
                end
                Stats[k] = [(ci_lower_bound(pos, DB[k].count, 0.975) * 100.0).round(0), pos, DB[k].count, indicator]
            end
        end
    end
    module_function :score
    #
    # reverse sort by confidence score and print to term
    #
    # we are only displaying whole number percentages in order to avoid the presception that this is accurate to
    # some decimal of score. we're trying to select scotches that have good confidence of being yummy and deserving
    # of the price via the sample of redditors.
    def run()
        parse_csv("lib/ratings.csv")
        score()
        Stats.sort_by {|k,i| -i[0]}.each {|k,i| (i[0] > 20.0 && (puts "#{k}: #{i[0]}% (#{i[1]}+, #{i[2]}#) #{i[3]}")) || nil}
    end
    module_function :run
end
