require 'csv'
require 'statistics2'

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
#db.each {|k,i| puts "#{k}: #{i}" }

db.keys.each do |k|
    pos = db[k].count {|x| x > 90 }
    stats[k] = [ci_lower_bound(pos, db[k].count, 0.975) * 100.0, pos]
end

stats.each {|k,i| (i[0] > 20.0 && (puts "#{k}: #{i}")) || nil}
