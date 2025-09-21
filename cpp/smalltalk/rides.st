"Ride base class"
Object subclass: Ride [
    | rideID pickupLocation dropoffLocation distance |

    Ride class >> id: id pickup: p drop: d distance: dist [
        ^self new
            rideID: id;
            pickupLocation: p;
            dropoffLocation: d;
            distance: dist;
            yourself
    ]

    rideID: anId [ rideID := anId ]
    pickupLocation: a [ pickupLocation := a ]
    dropoffLocation: a [ dropoffLocation := a ]
    distance: d [ distance := d ]

    fare [ self subclassResponsibility ]
    type [ self subclassResponsibility ]

    rideDetails [
        | f |
        f := self fare.
        Transcript
            show: '[' , self type , '] ' , rideID , ' ' , pickupLocation , ' -> ' , dropoffLocation;
            show: ' | distance: ' , distance printString , ' mi | fare: $' , f asFloat printString;
            cr.
    ]
]

"StandardRide"
Ride subclass: StandardRide [
    fare [
        | base perMile |
        base := 2.0.
        perMile := 1.5.
        ^ base + (perMile * distance)
    ]
    type [ ^ 'Standard' ]
]

"PremiumRide"
Ride subclass: PremiumRide [
    fare [
        | base perMile surge |
        base := 3.5.
        perMile := 2.75.
        surge := 1.2.
        ^ (base + (perMile * distance)) * surge
    ]
    type [ ^ 'Premium' ]
]

"Driver with encapsulated assignedRides"
Object subclass: Driver [
    | driverID name rating assignedRides |

    Driver class >> id: id name: nm rating: rt [
        ^self new
            driverID: id;
            name: nm;
            rating: rt;
            yourself
    ]

    initialize [ super initialize. assignedRides := OrderedCollection new. ]
    driverID: i [ driverID := i ]
    name: n [ name := n ]
    rating: r [ rating := r ]
    addRide: aRide [ assignedRides add: aRide ]

    getDriverInfo [
        Transcript show: 'Driver ' , name , ' (' , driverID , '), rating ' , rating printString; cr.
        Transcript show: 'Completed rides: ' , assignedRides size printString; cr.
    ]

    listRides [
        | total |
        total := 0.
        assignedRides do: [:r | r rideDetails. total := total + r fare ].
        Transcript show: 'Total earnings: $' , total printString; cr.
    ]
]

"Rider with encapsulated requestedRides"
Object subclass: Rider [
    | riderID name requestedRides |

    Rider class >> id: id name: nm [
        ^self new
            riderID: id;
            name: nm;
            yourself
    ]

    initialize [ super initialize. requestedRides := OrderedCollection new. ]
    riderID: i [ riderID := i ]
    name: n [ name := n ]
    requestRide: aRide [ requestedRides add: aRide ]

    viewRides [
        Transcript show: 'Rider ' , name , ' (' , riderID , ') ride history: ' , requestedRides size printString , ' rides'; cr.
        requestedRides do: [:r | r rideDetails ].
    ]
]

"Demo script"
| rides r1 r2 r3 d u |
rides := OrderedCollection new.
r1 := StandardRide id: 'R-1001' pickup: 'Airport' drop: 'Downtown' distance: 12.4.
r2 := PremiumRide id: 'R-1002' pickup: 'Campus' drop: 'Museum' distance: 6.1.
r3 := StandardRide id: 'R-1003' pickup: 'Stadium' drop: 'Hotel' distance: 3.8.
rides add: r1; add: r2; add: r3.

d := Driver id: 'D-77' name: 'Alex' rating: 4.94.
d addRide: r1. d addRide: r2. d addRide: r3.

u := Rider id: 'U-55' name: 'Haeri'.
u requestRide: r1. u requestRide: r3.

Transcript show: '=== Polymorphic ride listing ==='; cr.
rides do: [:r | r rideDetails ].

Transcript cr; show: '=== Driver details ==='; cr.
d getDriverInfo. d listRides.

Transcript cr; show: '=== Rider history ==='; cr.
u viewRides.

ObjectMemory quit.
