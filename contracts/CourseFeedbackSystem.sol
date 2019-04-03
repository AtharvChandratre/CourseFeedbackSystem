pragma solidity >=0.4.21 <0.6.0;

// This contract will be the backend smart contract for the course-feedback system, to interact with our blockchain
contract CourseFeedback{


  // Store students Count
  uint public studentsCount;
  //Store number of students who have voted till now
  uint numberOfVotedStudents=0;
  // Store admin credentials
  address admin;

  modifier onlyAdmin() {
    require (msg.sender==admin);
    _;
  }

  //structure to store candidate's details
  struct Student{
    uint studentID;
    string studentname;
    bool validStud;
    //feedback
  }

  //Store the Feedback received from the form
  struct Feedback {
    uint q1;
    uint q2;
    //Question variables go here
  }


  //Mappings
  // mapping of all the students :studentsList
  mapping (address=>Student) studentsList;
  //voted
  mapping (address=>bool) public voted;
  //mapping to store feedback
  mapping ( address => Feedback) public feedbackRecord;


  //constructor
  constructor() public {
    //initialise admin credentials
    admin=msg.sender;
    setNumberOfStudents(0);
  }


  function setNumberOfStudents (uint numberOfStudents) onlyAdmin public{
    //sets the number of students allowed to give reviews
    studentsCount=numberOfStudents;
  }


  //add students
  function addStudent (uint _studentid,string memory _studentname, address pk) onlyAdmin public {
    //making a new student struct
    studentsList[pk]=Student(_studentid,_studentname,true);
    //increase numberOfVotedStudents
    studentsCount++;
  }



  //give feedback
  function giveFeedback (uint a, uint b) public returns(uint) {
      // requires that they are in studentsList
      require(studentsList[msg.sender].validStud==true);
      // requires that they haven't given feedback before
      require(voted[msg.sender]==false);
      //add to feedbackRecord
      feedbackRecord[msg.sender] = Feedback(a,b);
      // update voted
      voted[msg.sender]=true;
      return uint(keccak256(abi.encode(msg.sender)));
  }


  // check feedback
  function checkFeedback() public view returns (uint, uint){
      //chekc if the student voted
      require(voted[msg.sender]== true);
      //check feedbackRecord
      return (feedbackRecord[msg.sender].q1,feedbackRecord[msg.sender].q2);

  }

  function getNoOfStudVoted() public view returns (uint)
  {
    return numberOfVotedStudents;
  }

  function getTotalStud() public view returns (uint)
  {
    return studentsCount;
  }

}

