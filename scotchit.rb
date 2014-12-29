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
require 'csv'
require 'statistics2'
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
#
# seeding the hashes
db = {}
stats = {}
#
# grok the ratings.csv file
CSV.foreach("ratings.csv", headers:true) do |row|
    # ignore non-Scotch things
    if %w[Bourbon Rye Grain Tennessee Liqueur Wheat].include? row['Region']
        next
    end
    # get the rating as an integer
    val = row['Rating'].to_i
    # seed key:val
    if !db.has_key?(row['Whisky Name'])
        db[row['Whisky Name']] = []
    end
    # append score
    db[row['Whisky Name']] << ((val == nil) ? 0 : val)
end
#
# do the confidence interval computations for all scotches meeting our thresholds.
db.keys.each do |k|
	if db[k].count > 5 # only eval whisky that has 6 or more reviews on reddit
		pos = db[k].count {|x| x > 90 } # threshold as positive vote 91+% rating
		stats[k] = [(ci_lower_bound(pos, db[k].count, 0.975) * 100.0).round(0), pos, db[k].count]
	end
end
#
# reverse sort by confidence score and print to term
#
# we are only displaying whole number percentages in order to avoid the presception that this is accurate to
# some decimal of score. we're trying to select scotches that have good confidence of being yummy and deserving
# of the price via the sample of redditors.
stats.sort_by {|k,i| -i[0]}.each {|k,i| (i[0] > 20.0 && (puts "#{k}: #{i[0]}% (#{i[1]}+, #{i[2]}#)")) || nil}
