const display = document.getElementById("display");

const buttons = document.querySelector(".btn");


let currentInput = "";
let previousInput = "";
let operator = "";


buttons.forEach((button)=>{
    button.addEventListeners('click',()=>{
        const value = button.dataset.value;
    });

    if(value === "c"){
        currentInput ="";
        previousInput = "";
        operator = "";
        updateDislay();
    
    }else if (value === "="){
        if(currentInput && previousInput && operator  ){
            currentInput = calculate(previousInput, currentInput, operator);
            previousInput = "";
            operator ="";
            updateDislay();
        }
    
    }else if(["+","-","*","/"]){
        if (currentInput){
            if(previousInput)
        }

    }

});
