pragma solidity >=0.4.21 <0.6.0;

// This contract will be the backend smart contract for the course-feedback system, to interact with our blockchain
contract CourseFeedback{

    uint private ctr=0;
  // Store students Count
  uint private studentsCount;
  //Store number of students who have voted till now
  uint private numberOfVotedStudents=0;
  // Store admin credentials
  address private admin;

  uint private totalQ1=0;
  uint private totalQ2=0;
  address usersAddresses[];

  modifier onlyAdmin() {
    require (msg.sender==admin);
    _;
  }

  //structure to store candidate's details
  struct Student{
    uint studentID;
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


  function setNumberOfStudents (uint numberOfStudents) public{
  	if(msg.sender!=admin)
	{
		revert("You are not an admin");
		
	}
    //sets the number of students allowed to give reviews
    studentsCount=numberOfStudents;
  }

  function checkAdmin(address _addr) public view returns (bool){
  	if(_addr==admin)
  	{
  		return true;
  	}
  	else
  	{
  		return false;
  	}
  }


  //add students
  function addStudent (uint _studentid, address pk) onlyAdmin private{
    //making a new student struct
    studentsList[pk]=Student(_studentid,true);
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
      totalQ1+=a;
      totalQ2+=b;
      return uint(keccak256(abi.encode(msg.sender)));
  }


  // check feedback
  function checkFeedbackQ1() public view returns (uint){
      //check if the student voted
      require(voted[msg.sender]== true);
      //check feedbackRecord
      return (feedbackRecord[msg.sender].q1);

  }

  function checkFeedbackQ2() public view returns (uint){
      //check if the student voted
      require(voted[msg.sender]== true);
      //check feedbackRecord
      return (feedbackRecord[msg.sender].q2);

  }
  
  function requestAddition() public{
      usersAddresses.push(msg.sender);
  }
  
    function addBulkStudents() onlyAdmin public{
        for( uint i=ctr;i<usersAddresses.length; i++)
        {
            addStudent(ctr,usersAddresses[ctr]);
            ctr++;
        }
    }
  function getNoOfStudVoted() public view returns (uint)
  {
    return numberOfVotedStudents;
  }

  function getTotalStud() public view returns (uint)
  {
    return studentsCount;
  }
  
  function returnTotalFeedbackQ1() public view returns(uint) {
  	return totalQ1;
  }

  function returnTotalFeedbackQ2() public view returns (uint) {
  	return totalQ2;
  }

}
