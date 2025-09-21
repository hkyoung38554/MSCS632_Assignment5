#include <iostream>
#include <vector>
#include <memory>
#include <string>
#include <iomanip>

class Ride {
protected:
    std::string rideID, pickupLocation, dropoffLocation;
    double distance;
public:
    Ride(std::string id, std::string pickup, std::string drop, double dist)
        : rideID(std::move(id)), pickupLocation(std::move(pickup)), dropoffLocation(std::move(drop)), distance(dist) {}
    virtual ~Ride() = default;

    virtual double fare() const = 0;
    virtual std::string type() const = 0;

    virtual void rideDetails(std::ostream& os) const {
        os << "[" << type() << "] " << rideID << " "
           << pickupLocation << " -> " << dropoffLocation
           << " | distance: " << distance << " mi | fare: $"
           << std::fixed << std::setprecision(2) << fare();
    }
};

class StandardRide : public Ride {
    double base = 2.00;
    double perMile = 1.50;
public:
    using Ride::Ride;
    double fare() const override { return base + perMile * distance; }
    std::string type() const override { return "Standard"; }
};

class PremiumRide : public Ride {
    double base = 3.50;
    double perMile = 2.75;
    double surge = 1.20;
public:
    using Ride::Ride;
    double fare() const override { return (base + perMile * distance) * surge; }
    std::string type() const override { return "Premium"; }
};

class Driver {
    std::string driverID, name;
    double rating;
    std::vector<std::shared_ptr<Ride>> assignedRides; // encapsulated
public:
    Driver(std::string id, std::string nm, double rt)
        : driverID(std::move(id)), name(std::move(nm)), rating(rt) {}

    void addRide(const std::shared_ptr<Ride>& ride) { assignedRides.push_back(ride); }

    void getDriverInfo(std::ostream& os) const {
        os << "Driver " << name << " (" << driverID << "), rating " << rating << "\n";
        os << "Completed rides: " << assignedRides.size() << "\n";
    }

    void listRides(std::ostream& os) const {
        double total = 0.0;
        for (const auto& r : assignedRides) {
            r->rideDetails(os);
            os << "\n";
            total += r->fare();
        }
        os << "Total earnings: $" << std::fixed << std::setprecision(2) << total << "\n";
    }
};

class Rider {
    std::string riderID, name;
    std::vector<std::shared_ptr<Ride>> requestedRides; // encapsulated
public:
    Rider(std::string id, std::string nm) : riderID(std::move(id)), name(std::move(nm)) {}

    void requestRide(const std::shared_ptr<Ride>& ride) { requestedRides.push_back(ride); }

    void viewRides(std::ostream& os) const {
        os << "Rider " << name << " (" << riderID << ") ride history: "
           << requestedRides.size() << " rides\n";
        for (const auto& r : requestedRides) {
            r->rideDetails(os);
            os << "\n";
        }
    }
};

int main() {
    // Polymorphic list of rides
    std::vector<std::shared_ptr<Ride>> rides;
    auto r1 = std::make_shared<StandardRide>("R-1001","Airport","Downtown",12.4);
    auto r2 = std::make_shared<PremiumRide>("R-1002","Campus","Museum",6.1);
    auto r3 = std::make_shared<StandardRide>("R-1003","Stadium","Hotel",3.8);
    rides.push_back(r1); rides.push_back(r2); rides.push_back(r3);

    Driver d("D-77","Alex",4.94);
    d.addRide(r1); d.addRide(r2); d.addRide(r3);

    Rider u("U-55","Haeri");
    u.requestRide(r1); u.requestRide(r3);

    std::cout << "=== Polymorphic ride listing ===\n";
    for (const auto& r : rides) {
        r->rideDetails(std::cout);
        std::cout << "\n";
    }

    std::cout << "\n=== Driver details ===\n";
    d.getDriverInfo(std::cout);
    d.listRides(std::cout);

    std::cout << "\n=== Rider history ===\n";
    u.viewRides(std::cout);

    return 0;
}
