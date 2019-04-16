const CourseFeedbackSystem = artifacts.require('./CourseFeedbackSystem.sol')

contract('CourseFeedbackSystem', (accounts) => {
  beforeEach(async () => {
    this.CourseFeedbackSystem = await CourseFeedbackSystem.deployed()
  })

  it('Deploys Successfully', async () => {
    const address = await this.CourseFeedbackSystem.address
    assert.notEqual(address, 0x0)
    assert.notEqual(address, '')
    assert.notEqual(address, null)
    assert.notEqual(address, undefined)
  })

  it('Sets number of students correctly', async () => {
    const tempNumberOfStudents = Math.floor(Math.random() * 10);
    await this.CourseFeedbackSystem.setNumberOfStudents(tempNumberOfStudents)
    const tempReturnValue = await this.CourseFeedbackSystem.getTotalStud()
    assert.equal(tempNumberOfStudents,tempReturnValue)
  })

  
})