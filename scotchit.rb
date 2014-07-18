require 'csv'
require 'statistics2'

# Evan Miller's Wilson Score Interval fn
def ci_lower_bound(pos, n, confidence)
    if n == 0
        return 0
    end
    z = Statistics2.pnormaldist(1-(1-confidence)/2)
    phat = 1.0*pos/n
    (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
end

db = {}
stats = {}

CSV.foreach("ratings.csv", headers:true) do |row|
    val = row['Reviewer Rating'].to_i
    if !db.has_key?(row['whisky name'])
        db[row['whisky name']] = []
    end
    db[row['whisky name']] << ((val == nil) ? 0 : val)
end

db.keys.each do |k|
	if db[k].count > 5 # only eval whisky that has 6 or more reviews on reddit
		pos = db[k].count {|x| x > 90 } # threshold as positive vote 91+% rating
		stats[k] = [ci_lower_bound(pos, db[k].count, 0.975) * 100.0, pos, db[k].count]
	end
end

# reverse sort by confidence score and print to term
stats.sort_by {|k,i| -i[0]}.each {|k,i| (i[0] > 20.0 && (puts "#{k}: #{i}")) || nil}
