import * as functions from './functions'

let isAdmin

const adminRoutes = [1,8,9,10,11,12]
const studentRoutes = [1,2,3,4,5,6,7]
const screens = [...document.querySelectorAll('.screen')]

function changeScreen(newID) {
    const id = parseInt(newID, 10)

    if(isAdmin && !adminRoutes.includes(id)) {
        return changeScreen(12)
    } else if(!isAdmin && !studentRoutes.includes(id)) {
        return changeScreen(7)
    }
    screens.forEach(screen => screen.classList.remove('active'))
    document.getElementById(`screen${id}`).classList.add('active')
}

async function changeScreenAsync(next, type) {
    if(type == 'feedback-submit') {
        const q1 = parseInt(document.getElementById('question1').value, 10)
        const q2 = parseInt(document.getElementById('question2').value, 10)

        await functions.feedbackSubmit(q1, q2)
    } else if(type == 'check-student-feedback') {
        await functions.onStudentFeedbackCheck()
    } else if(type == 'add-student') {
        const id = parseInt(document.getElementById('student-id').value, 10)
        const name = document.getElementById('student-name').value
        const addr = document.getElementById('student-address').value

        await functions.addStudent(id, name, addr)
    } else if(type == 'check-admin-feedback') {
        await functions.onAdminFeedbackCheck()
    }
    changeScreen(next)
}

function init() {
    const clickables = [...document.querySelectorAll('[data-next]')]
    clickables.forEach(clickable => {
        clickable.addEventListener('click', _ => changeScreen(clickable.dataset.next))
    })

    const callbacks = [...document.querySelectorAll('[data-cbnext]')]
    callbacks.forEach(cb => {
        const next = cb.dataset.cbnext
        const intent = cb.dataset.intent
        cb.addEventListener('click', _ => changeScreenAsync(next, intent))
    })


    while(true) {
        isAdmin = parseInt(prompt('Is admin?', '1'), 10)
        if(isAdmin == 1 || isAdmin == 0) break
        alert('Enter either 1 or 0')
        console.log(isAdmin)
    }
}

function modifyStudentFeedbackID(newID) {
    document.getElementById('feedback-id').innerText = newID
}

function modifyHeaderAddress(id) {
    document.getElementById('wallet-address').innerText = id
}

function generateFeedback(data) {
    let html = `
    <div class="row first">
        <h2>No. of students</h2>
        <input type="number" disabled value="${data.length}" />
    </div>
    `
    data.forEach(entry => {
        html += `
        <div class="row">
            <h2>Q1 Feedback</h2>
            <input type="number" disabled value="${entry.q1}" />
        </div>
        <div class="row">
            <h2>Q2 Feedback</h2>
            <input type="number" disabled value="${entry.q2}" />
        </div>
        `
    })
    document.getElementById('admin-feedback').innerHTML = html
}

init()

export { generateFeedback, modifyStudentFeedbackID, modifyHeaderAddress }