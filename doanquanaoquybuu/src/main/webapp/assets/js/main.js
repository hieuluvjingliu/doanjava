function slideToggle(t,e,o){0===t.clientHeight?j(t,e,o,!0):j(t,e,o)}function slideUp(t,e,o){j(t,e,o)}function slideDown(t,e,o){j(t,e,o,!0)}function j(t,e,o,i){void 0===e&&(e=400),void 0===i&&(i=!1),t.style.overflow="hidden",i&&(t.style.display="block");var p,l=window.getComputedStyle(t),n=parseFloat(l.getPropertyValue("height")),a=parseFloat(l.getPropertyValue("padding-top")),s=parseFloat(l.getPropertyValue("padding-bottom")),r=parseFloat(l.getPropertyValue("margin-top")),d=parseFloat(l.getPropertyValue("margin-bottom")),g=n/e,y=a/e,m=s/e,u=r/e,h=d/e;window.requestAnimationFrame(function l(x){void 0===p&&(p=x);var f=x-p;i?(t.style.height=g*f+"px",t.style.paddingTop=y*f+"px",t.style.paddingBottom=m*f+"px",t.style.marginTop=u*f+"px",t.style.marginBottom=h*f+"px"):(t.style.height=n-g*f+"px",t.style.paddingTop=a-y*f+"px",t.style.paddingBottom=s-m*f+"px",t.style.marginTop=r-u*f+"px",t.style.marginBottom=d-h*f+"px"),f>=e?(t.style.height="",t.style.paddingTop="",t.style.paddingBottom="",t.style.marginTop="",t.style.marginBottom="",t.style.overflow="",i||(t.style.display="none"),"function"==typeof o&&o()):window.requestAnimationFrame(l)})}

let sidebarItems = document.querySelectorAll('.sidebar-item.has-sub');
for(var i = 0; i < sidebarItems.length; i++) {
    let sidebarItem = sidebarItems[i];
	sidebarItems[i].querySelector('.sidebar-link').addEventListener('click', function(e) {
        e.preventDefault();
        
        let submenu = sidebarItem.querySelector('.submenu');
        if( submenu.classList.contains('active') ) submenu.style.display = "block"

        if( submenu.style.display == "none" ) submenu.classList.add('active')
        else submenu.classList.remove('active')
        slideToggle(submenu, 300)
    })
}

window.addEventListener('DOMContentLoaded', (event) => {
    var w = window.innerWidth;
    if(w < 1200) {
        document.getElementById('sidebar').classList.remove('active');
    }
});
window.addEventListener('resize', (event) => {
    var w = window.innerWidth;
    if(w < 1200) {
        document.getElementById('sidebar').classList.remove('active');
    }else{
        document.getElementById('sidebar').classList.add('active');
    }
});

const burgerBtn = document.querySelector('.burger-btn');
if (burgerBtn) {
    burgerBtn.addEventListener('click', () => {
        document.getElementById('sidebar').classList.toggle('active');
    });
}
const sidebarHide = document.querySelector('.sidebar-hide');
if (sidebarHide) {
    sidebarHide.addEventListener('click', () => {
        document.getElementById('sidebar').classList.toggle('active');
    });
}


// #region agent log (debug-c40847)
fetch('http://127.0.0.1:7814/ingest/a3fc902f-fb28-4b1a-b1fe-f30f1ae3eaf2',{method:'POST',headers:{'Content-Type':'application/json','X-Debug-Session-Id':'c40847'},body:JSON.stringify({sessionId:'c40847',location:'main.js:1',message:'main.js loaded',data:{hypothesisId:'A',url:location.href,hasNullCheck:true},timestamp:Date.now()})}).catch(()=>{});
// #endregion

// Perfect Scrollbar Init
if(typeof PerfectScrollbar == 'function') {
    const container = document.querySelector(".sidebar-wrapper");
    const ps = new PerfectScrollbar(container, {
        wheelPropagation: false
    });
}

// #region agent log (debug-c40847)
try {
    const active = document.querySelector('.sidebar-item.active');
    const sidebarExists = document.getElementById('sidebar') !== null;
    fetch('http://127.0.0.1:7814/ingest/a3fc902f-fb28-4b1a-b1fe-f30f1ae3eaf2',{method:'POST',headers:{'Content-Type':'application/json','X-Debug-Session-Id':'c40847'},body:JSON.stringify({sessionId:'c40847',location:'main.js:55',message:'pre-scrollIntoView check',data:{hypothesisId:'B',activeEl:active?active.outerHTML.substring(0,100):null,sidebarExists,sidebarItemCount:document.querySelectorAll('.sidebar-item').length},timestamp:Date.now()})}).catch(()=>{});
} catch(e) {
    fetch('http://127.0.0.1:7814/ingest/a3fc902f-fb28-4b1a-b1fe-f30f1ae3eaf2',{method:'POST',headers:{'Content-Type':'application/json','X-Debug-Session-Id':'c40847'},body:JSON.stringify({sessionId:'c40847',location:'main.js:55',message:'error before scrollIntoView',data:{hypothesisId:'B',error:e.message},timestamp:Date.now()})}).catch(()=>{});
}
// #endregion

// Scroll into active sidebar
const activeSidebarItem = document.querySelector('.sidebar-item.active');
if (activeSidebarItem) {
    activeSidebarItem.scrollIntoView(false);
}