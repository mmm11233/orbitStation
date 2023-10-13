
class StationModule {
    let moduleName: String
    var drone: Drone?
    
    init(moduleName: String) {
        self.moduleName = moduleName
    }
    
    func getTask(_ drone: Drone) {
        self.drone = drone
    }
}


class ControlCenter: StationModule {
    var isLockeddown: Bool = false
    var securityCode: String
    
    init(moduleName: String, securityCode: String) {
        self.securityCode = securityCode
        super.init(moduleName: moduleName)
    }
    
    func lockdown(password: String) {
        if password == securityCode {
            isLockeddown = true
            print("Control Center is locked down.")
        } else {
            print("controllCentere isnot lockeddown")
        }
    }
    
}



class ResearchLab: StationModule {
    var samples: [String] = []
    
    
    func addSamples(addSample: String) {
        samples.append(addSample)
    }
}



class LifeSupportSystem: StationModule {
    let oxygenLevel: Int = 100
    
    func oxygenStatus() {
        print("oxygen level is: \(oxygenLevel) %")
    }
}



class Drone {
    var task: String?
    unowned var assignedModule: StationModule;
    weak var missionControlLink: MissionControl?
    
    init(assignedModule: StationModule) {
        self.assignedModule = assignedModule
    }
    
    func checkIfTaskAvailable() {
        if let task = task {
            print("Drone assigned to \(assignedModule.moduleName) and performing task is: \(task)")
        } else {
            print("there is no task")
        }
    }
    
}



class OrbitronSpaceStation {
    let controlCenter: ControlCenter
    let researchLab: ResearchLab
    let lifeSupportSystem: LifeSupportSystem
    
    init(controlCenter: ControlCenter,
         researchLab: ResearchLab,
         lifeSupportSystem: LifeSupportSystem) {
        self.controlCenter = controlCenter
        self.researchLab = researchLab
        self.lifeSupportSystem = lifeSupportSystem
    }
    
    func lockdown(password: String) {
        controlCenter.lockdown(password: password)
    }
    
}



class MissionControl {
    var spaceStation: OrbitronSpaceStation?
    
    func conectToOrbitronSpaceStation(spaceStation: OrbitronSpaceStation) {
        self.spaceStation = spaceStation
    }
    
    func requestControlCenterStatus() {
        print("control Center Lockdown Status: \(spaceStation?.controlCenter.isLockeddown ?? false)")
    }
    
    func requestOxygenStatus() {
        print("oxygen status is: \(String(describing: spaceStation?.lifeSupportSystem.oxygenStatus()))")
    }
    
    func requestDroneStatus(forModule moduleName: String) {
        if let drone = spaceStation?.controlCenter.drone, drone.assignedModule.moduleName == moduleName {
            drone.checkIfTaskAvailable()
        }
    }
}



let controlCenter = ControlCenter(moduleName: "Control Center", securityCode: "controlCenter12")
let researchLab = ResearchLab(moduleName: "Research Center")
let lifeSupportSystem = LifeSupportSystem(moduleName: "life Support System")

let drone1 = Drone(assignedModule: controlCenter)
let drone2 = Drone(assignedModule: researchLab)
let drone3 = Drone(assignedModule: lifeSupportSystem)

controlCenter.getTask(drone1)
researchLab.getTask(drone2)
lifeSupportSystem.getTask(drone3)

let spaceStation = OrbitronSpaceStation(controlCenter: controlCenter, researchLab: researchLab, lifeSupportSystem: lifeSupportSystem)

let missionControl = MissionControl()
missionControl.conectToOrbitronSpaceStation(spaceStation: spaceStation)

missionControl.requestControlCenterStatus()
missionControl.requestOxygenStatus()

drone1.task = "Receive an emergency signal"
drone2.task = "check oxygen level"
drone3.task = "check air humidity"

missionControl.requestDroneStatus(forModule: "Control Center")
missionControl.requestDroneStatus(forModule: "Research Lab")
missionControl.requestDroneStatus(forModule: "Life Support System")

spaceStation.lockdown(password: "controlCenter2")

